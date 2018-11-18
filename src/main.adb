---
-- Mozzoni is a safe, multi-core capable NoSQL data service


with Ada.Streams;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;

with Mozzoni;

procedure Main is
   Server_Sock : Socket_Type;
   Server_Addr : Sock_Addr_Type;

   type Command_Type is (None, Simple_String, Error, Int, Bulk, List);

   procedure Prepare_Address (SA : in out Sock_Addr_Type) is
   begin
      SA.Port := Port_Type (Mozzoni.Port);
      SA.Addr := Inet_Addr (Mozzoni.Default_Bind);
   end Prepare_Address;
   -- Initialize the Sock_Addr_Type necessary to create the server's
   -- socket bind
   --
   -- @param SA An uninitialized GNAT.Sockets.Sock_Addr_Type record

   function  Wait_For_Connection (Sock : in Socket_Type;
                                  SA   : in out Sock_Addr_Type) return Socket_Type is
      Client_Sock : Socket_Type;
   begin
      Accept_Socket (Sock, Client_Sock, SA);
      Put_Line ("Accepted socket connection");
      return Client_Sock;

   end Wait_For_Connection;
   -- Blocking call to wait for a client to connect on the socket's port

   procedure Handle_Simple_String (Buffer : in Unbounded_String) is
   begin
      Put_Line ("Received simple string: " & To_String (Buffer));
   end Handle_Simple_String;

   procedure Handle_Error (Buffer : In Unbounded_String) is
   begin
      Put_Line ("Received error: " & To_String (Buffer));
   end Handle_Error;

   procedure Handle_Integer (Buffer : in Unbounded_String) is
      Value : Integer := Integer'Value (To_String (Buffer));
   begin
      Put_Line ("Received integer: " & Integer'Image (Value));
      if Value < 9000 then
         Put_Line ("..it's not under 9000");
      else
         Put_Line ("..it's over 9000!");
      end if;
   end Handle_Integer;

   procedure Handle_Bulk (Channel : in Stream_Access;
                          Buffer : in Unbounded_String) is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Expected_Size : constant Stream_Element_Offset := Stream_Element_Offset'Value (To_String (Buffer));
      -- We expect to also read the trailing \r\n here
      Bulk_Buffer : Stream_Element_Array (1 .. (Expected_Size + 2));
      Offset : Stream_Element_Count;
      -- TODO:: Expected_Size will be 64 bits, on 32 bit platforms Integer may
      -- not be 32 bits as well, and we might truncate here.
      Bulk_String : String (1 .. Integer (Expected_Size));

      IterInt : Integer;
   begin
      Put_Line (To_String (Buffer));
      Read (Channel.all, Bulk_Buffer, Offset);
      -- TODO: what to do when Offset != Expected_Size?
      if Offset /= (Expected_Size  + 2) then
         Put_Line ("Handle_Bulk: offset does not equal expected size");
         Put_Line ("   offset:" & Stream_Element_Count'Image (Offset));
         Put_Line (" expected:" & Stream_Element_Offset'Image (Expected_Size));
      end if;

      for Index in Bulk_Buffer (1 .. Expected_Size)'Range loop
         IterInt := Integer (Index);
         Bulk_String (IterInt) := Character'Val (Bulk_Buffer (Index));
      end loop;
      Put_Line ("Bulk read: " & Bulk_String);

      if Bulk_String = "PING" then
         String'Write (Channel, "+PONG" & CR & LF);
      end if;

   end Handle_Bulk;
   -- Handle_Bulk will appropriate allocate and read the bulk string in from
   -- the given Channel


   procedure Handle_Client_Commands (Sock : in Socket_Type) is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Channel : Stream_Access := Stream (Sock);
      -- The minimum buffer size in RESP is four bytes
      -- [type][buffer][crlf]
      Buffer  : Stream_Element_Array (1 .. 4);
      -- TODO: need to investigate what happens here when the command payload
      -- does not fall on a four byte boundary.
      Offset : Stream_Element_Count;

      Current_Command : Command_Type := None;
      Byte : Character := NUL;

      Command : Unbounded_String;
      Exiting : Boolean := False;
   begin
      Put_Line ("Handle_Client_Commands");
      loop
         Read (Channel.all, Buffer, Offset);
         exit when Offset = 0;

         for Ch of Buffer loop
            Byte := Character'Val (Ch);

            if Current_Command = None then
               -- We're at the start of a buffer
               case Byte is
               when '+' => Current_Command := Simple_String;
               when '-' => Current_Command := Error;
               when ':' => Current_Command := Int;
               when '$' => Current_Command := Bulk;
               when '*' => Current_Command := List;
               when others => null;
               end case;

               Put_Line ("Current command is: " & Command_Type'Image (Current_Command));
            else
               -- We should be receiving the content itself
               if Byte = CR then
                  Exiting := True;
               elsif Exiting and Byte = LF then
                  -- We have completed receiving a single command
                  case Current_Command is
                     when Simple_String => Handle_Simple_String (Command);
                     when Error => Handle_Error (Command);
                     when Int => Handle_Integer (Command);
                     when Bulk =>
                        Handle_Bulk (Channel, Command);
                     when others => null;
                  end case;
                  Current_Command := None;
                  Exiting := False;
                  Byte := NUL;
                  Delete (Command, 1, Length (Command));
               else
                  Append (Command, Byte);
               end if;
            end if;
         end loop;
      end loop;

      Put_Line ("Closing connection");
      -- XXX: Temporary close socket immediately
      Close_Socket (Sock);
   end Handle_Client_Commands;

begin
   -- Initialize GNAT.Sockets
   Initialize;
   Prepare_Address (Server_Addr);

   Create_Socket (Server_Sock);
   Set_Socket_Option (Server_Sock, Socket_Level, (Reuse_Address, True));

   Bind_Socket (Server_Sock, Server_Addr);
   Listen_Socket (Server_Sock);

   Put_Line ("mozzinid online and ready for work..");

   loop
      Handle_Client_Commands (
                              Wait_For_Connection (Server_Sock, Server_Addr)
                             );
   end loop;

end Main;
