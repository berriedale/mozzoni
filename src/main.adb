--
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

with Interfaces.C;
with Epoll;

with Mozzoni.Client;

procedure Main is
   Server_Sock : Socket_Type;
   Server_Addr : Sock_Addr_Type;

   EpollFD     : Epoll.Epoll_Fd_Type;
   Event       : aliased Epoll.Event_Type;
   Events      : Epoll.Event_Array_Type (1 .. 10);
   Return_Value, Descriptors : Integer;

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

      Put_Line ("Closing connection");
      -- XXX: Temporary close socket immediately
      Close_Socket (Sock);
   end Read_Client_Commands;

   Client_Socket : Socket_Type;
   Socket_Request : Request_Type := (Non_Blocking_IO, True);

begin

   Mozzoni.Command_Loader.Load;

   -- Initialize GNAT.Sockets
   Initialize;
   Prepare_Address (Server_Addr);

   Create_Socket (Server_Sock);
   Set_Socket_Option (Server_Sock, Socket_Level, (Reuse_Address, True));

   Bind_Socket (Server_Sock, Server_Addr);
   Listen_Socket (Server_Sock);
   EpollFD := Epoll.Create (Events'Last + 1);

   if EpollFD = -1 then
      Put_Line ("Failed to create epoll(7) file descriptor");
      return;
   end if;

   Event.Events := Epoll.Epoll_In;
   Event.Data.FD := Server_Sock;

   Return_Value := Epoll.Control (EpollFD, Epoll.Epoll_Ctl_Add, To_C (Server_Sock), Event'Access);


   Put_Line ("mozzinid online and ready for work..");

   loop
      Descriptors := 0;
      Descriptors := Epoll.Wait (EpollFD, Events (Events'First)'Access, 10, -1);

      for Index in 1 .. Descriptors loop
         declare
            Polled_Event : Epoll.Event_Type := Events (Integer (Index));
            Client : Mozzoni.Client.Client_Type;
         begin
            if Polled_Event.Data.FD = Server_Sock then
               -- Accept the new connection
               Accept_Socket (Server_Sock, Client_Socket, Server_Addr);
               Control_Socket (Client_Socket, Socket_Request);

               Event.Events := Epoll.Epoll_In_And_Et;
               Event.Data.FD := Client_Socket;

               Return_Value := Epoll.Control (EpollFD,
                                              Epoll.Epoll_Ctl_Add,
                                              To_C (Client_Socket),
                                              Event'Access);

               Mozzoni.Client.Register_Client (Client_Socket);
               Put_Line ("accepted...");
            else
               Client := Mozzoni.Client.Client_For (Polled_Event.Data.FD);
               Client.Read_Available (Polled_Event.Data.FD);
            end if;
         end;
      end loop;
   end loop;

end Main;
