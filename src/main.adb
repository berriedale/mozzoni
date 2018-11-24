---
-- Mozzoni is a safe, multi-core capable NoSQL data service


with Ada.Exceptions;
with Ada.Streams;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;

with Mozzoni.Command_Loader;
with Mozzoni; use Mozzoni;
with Mozzoni.Parser; use Mozzoni.Parser;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;

procedure Main is
   Server_Sock : Socket_Type;
   Server_Addr : Sock_Addr_Type;

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
      return Client_Sock;
   end Wait_For_Connection;


   procedure Read_Client_Commands (Sock : in Socket_Type) is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Channel : Stream_Access := Stream (Sock);
      Buffer  : Stream_Element_Array (1 .. 1);
      Offset : Stream_Element_Count;

      Current_RESP : RESP_Type := None;
      Byte : Character := NUL;

      Command : Unbounded_String;
      Parsed_Command : Command_Array_Access;
      Exiting : Boolean := False;
   begin
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
                  -- when others we're likely seeing a "simple" command, in which case
                  -- we need to parse it differently
               when others =>
                  Current_RESP := Human_Readable;
                  Append (Command, Byte);
               end case;
            else
               -- We should be receiving the content itself
               if Byte = CR then
                  Exiting := True;
               elsif Exiting and Byte = LF then
                  -- We have completed receiving a single command
                  case Current_RESP is
                     when List =>
                        Parsed_Command := Read_Command_List (Channel, To_Natural (Command));
                        -- Print (Parsed_Command);
                        Dispatch_Command (Channel, Parsed_Command);
                     when Human_Readable =>
                        Dispatch_Command (Channel, Parse_Human_Readable_Command (Command));
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

      -- XXX: Temporary close socket immediately
      Close_Socket (Sock);
   end Read_Client_Commands;


   task type Client_Handler_Task is
      entry Read_Commands (S : in Socket_Type);
   end Client_Handler_Task;

   task body Client_Handler_Task is

   begin
      loop
         accept Read_Commands (S : in Socket_Type) do
            Read_Client_Commands (S);
         end Read_Commands;
      end loop;
   end Client_Handler_Task;
   type Client_Handler_Task_Access is access all Client_Handler_Task;
   type Client_Handler_Task_Array is array (Positive range <>) of Client_Handler_Task_Access;

   Workers : Client_Handler_Task_Array (1 .. 50) := (others => new Client_Handler_Task);
   Current_Worker : Natural := 1;
   Client_Socket : Socket_Type;
begin

   Mozzoni.Command_Loader.Load;

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
         if Current_Worker > Workers'Length then
            Current_Worker := 1;
         end if;

         Client_Socket := Wait_For_Connection (Server_Sock, Server_Addr);
         Workers (Current_Worker).Read_Commands (Client_Socket);
         Current_Worker := Current_Worker + 1;
      exception
         when Event : others =>
            Put_Line ("Failure handling connection!");
            Put_Line (Ada.Exceptions.Exception_Message (Event));
      end;
   end loop;

end Main;
