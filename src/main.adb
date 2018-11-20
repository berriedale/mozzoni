---
-- Mozzoni is a safe, multi-core capable NoSQL data service


with Ada.Exceptions;
with Ada.Streams;
with Ada.Characters.Latin_1;
with Ada.Unchecked_Conversion;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;

with Mozzoni; use Mozzoni;

procedure Main is
   Server_Sock : Socket_Type;
   Server_Addr : Sock_Addr_Type;

   function Convert_Byte is new Ada.Unchecked_Conversion (Ada.Streams.Stream_Element, Character);
   function To_Natural (Buffer : in Unbounded_String) return Natural is
   begin
      return Natural'Value (To_String (Buffer));
   end To_Natural;


   -- Initialize the Sock_Addr_Type necessary to create the server's
   -- socket bind
   --
   -- @param SA An uninitialized GNAT.Sockets.Sock_Addr_Type record
   procedure Prepare_Address (SA : in out Sock_Addr_Type) is
   begin
      SA.Port := Port_Type (Mozzoni.Port);
      SA.Addr := Inet_Addr (Mozzoni.Default_Bind);
   end Prepare_Address;


   -- Blocking call to wait for a client to connect on the socket's port
   function  Wait_For_Connection (Sock : in Socket_Type;
                                  SA   : in out Sock_Addr_Type) return Socket_Type is
      Client_Sock : Socket_Type;
   begin
      Accept_Socket (Sock, Client_Sock, SA);
      Put_Line ("Accepted socket connection");
      return Client_Sock;
   end Wait_For_Connection;

   -- Handle_Bulk will appropriate allocate and read the bulk string in from
   -- the given Channel
   function Read_Bulk (Channel : in Stream_Access;
                       Length : in Natural) return Unbounded_String is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Expected_Size : constant Stream_Element_Offset := Stream_Element_Offset (Length);
      -- TODO:: Expected_Size will be 64 bits, on 32 bit platforms Integer may
      -- not be 32 bits as well, and we might truncate here.
      Bulk_String   : String (1 .. (Length + 2));
   begin
      String'Read (Channel, Bulk_String);
      -- Trim the trailing \r\n before returning.
      return To_Unbounded_String (Bulk_String (1  .. Length));
   end Read_Bulk;


   --
   -- Read_To_CRLF will read the remainder of the line in the Channel until
   -- it reaches the expected \r\n which indicates the end of an entry in RESP
   --
   -- @return An unprocessed/parsed and unbounded string
   function Read_To_CRLF (Channel : in Stream_Access) return Unbounded_String is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Bytes : Stream_Element_Array (1 .. 1);
      Offset : Stream_Element_Count;
      Exiting : Boolean := False;
      Char : Character := NUL;

      Buffer : Unbounded_String;
   begin
      loop
         Read (Channel.all, Bytes, Offset);
         exit when Offset = 0;

         Char := Convert_Byte (Bytes (1));

         case Char is
            when CR =>
               Exiting := True;
            when LF =>
               exit when Exiting;
            when others =>
               Append (Buffer, Char);
         end case;
      end loop;
      return Buffer;
   end Read_To_CRLF;


   -- Read_Item will read from the given Channel and return a single RESP_Item
   -- which represents a single type of "thing" in RESP, such as a Simple String
   -- an Integer, an Error, etc.
   function Read_Item (Channel : in Stream_Access) return RESP_Item_Access is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Bytes : Stream_Element_Array (1 .. 1);
      Offset : Stream_Element_Count;
      Exiting : Boolean := False;
      Char : Character := NUL;

      Buffer : Unbounded_String;
      Item_Type : RESP_Type := None;
      Bulk_Read_Length : Natural := 0;
   begin
      loop
         Bulk_Read_Length := 0;

         Read (Channel.all, Bytes, Offset);
         exit when Offset = 0;
         Char := Convert_Byte (Bytes (1));

         case Char is
            when '+' =>
               -- Simple String
               Buffer := Read_To_CRLF (Channel);
               Item_Type := Simple_String;
            when ':' =>
               -- Integer
               Buffer := Read_To_CRLF (Channel);
               Item_Type := Int;
            when '$' =>
               -- First read the length
               Buffer := Read_To_CRLF (Channel);
               Bulk_Read_Length := To_Natural (Buffer);
               Buffer := Read_Bulk (Channel, Bulk_Read_Length);
               Item_Type := Bulk;
            when others => null;
         end case;
      end loop;

      declare
         Item : RESP_Item_Access := new RESP_Item (Item_Type);
      begin
         case Item_Type is
            when Simple_String =>
               Item.Value := Buffer;
            when Int =>
               Item.Number := Integer'Value (To_String (Buffer));
            when Bulk =>
               Item.Buffer := Buffer;
            when others => null;
         end case;
         Item.Valid := True;
         return Item;
      end;
   end Read_Item;

   procedure Print_Command (Command_Access : in Command_Type_Access) is
      Command : Command_Type := Command_Access.all;
      Index : Natural := 1;
   begin
      for Item of Command.Items loop
         Put (Natural'Image (Index) & ": ");
         case Item.all.Item_Type is
            when Simple_String => Put_Line (To_String (Item.all.Value));
            when Int => Put_Line (Integer'Image (Item.all.Number));
            when Bulk => Put_Line (To_String (Item.all.Buffer));
            when others => null;
         end case;

      end loop;
   end Print_Command;

   function  Handle_Command_List (Channel : in Stream_Access;
                                  Count   : in Natural) return Command_Type_Access is
      Command_Access : Command_Type_Access := new Command_Type (Count);
      Command : Command_Type := Command_Access.all;
   begin
      for Index in 1 .. Count loop
         Command.Items (Index) := Read_Item (Channel);
      end loop;
      return Command_Access;
   end Handle_Command_List;


   procedure Read_Client_Commands (Sock : in Socket_Type) is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Channel : Stream_Access := Stream (Sock);
      Buffer  : Stream_Element_Array (1 .. 1);
      Offset : Stream_Element_Count;

      Current_RESP : RESP_Type := None;
      Byte : Character := NUL;

      Command : Unbounded_String;
      Exiting : Boolean := False;

      Parsed_Command : Command_Type_Access;
   begin
      Put_Line ("Handle_Client_Commands");
      loop
         Read (Channel.all, Buffer, Offset);
         exit when Offset = 0;

         for Ch of Buffer loop
            Byte := Convert_Byte (Ch);

            if Current_RESP = None then
               -- We're at the start of a buffer
               case Byte is
               when '+' => Current_RESP := Simple_String;
               when '-' => Current_RESP := Error;
               when ':' => Current_RESP := Int;
               when '$' => Current_RESP := Bulk;
               when '*' => Current_RESP := List;
               when others => null;
               end case;
            else
               -- We should be receiving the content itself
               if Byte = CR then
                  Exiting := True;
               elsif Exiting and Byte = LF then
                  -- We have completed receiving a single command
                  case Current_RESP is
                     when List =>
                        Parsed_Command := Handle_Command_List (Channel, To_Natural (Command));
                        Print_Command (Parsed_Command);
                     when others => null;
                  end case;
                  Current_RESP := None;
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
   end Read_Client_Commands;

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
      begin
         Read_Client_Commands (Wait_For_Connection (Server_Sock, Server_Addr));
      exception
         when Event : others =>
            Put_Line ("Failure handling connection!");
            Put_Line (Ada.Exceptions.Exception_Message (Event));
      end;
   end loop;

end Main;
