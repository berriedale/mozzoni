--
-- Mozzoni is a safe, multi-core capable NoSQL data service


with Ada.Exceptions;
with Ada.Streams;
with Alog;
with Epoll;
with Interfaces.C;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

with Mozzoni.Command_Loader;
with Mozzoni.Client;

with Mozzoni; use Mozzoni;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;


procedure Main is
   Server_Sock : Socket_Type;
   Server_Addr : Sock_Addr_Type;

   EpollFD     : Epoll.Epoll_Fd_Type;
   Event       : aliased Epoll.Event_Type;
   Events      : Epoll.Event_Array_Type (1 .. 1);
   Return_Value, Descriptors : Integer;

   -- Initialize the Sock_Addr_Type necessary to create the server's
   -- socket bind
   --
   -- @param SA An uninitialized GNAT.Sockets.Sock_Addr_Type record
   procedure Prepare_Address (SA : in out Sock_Addr_Type) is
   begin
      SA.Port := Port_Type (Mozzoni.Port);
      SA.Addr := Inet_Addr (Mozzoni.Default_Bind);
   end Prepare_Address;


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
   EpollFD := Epoll.Create (Events'Length);

   if EpollFD = -1 then
      Log.Log_Message (Alog.Error, "Failed to create epoll(7) file descriptor");
      return;
   end if;

   Event.Events := Epoll.Epoll_In_And_Out;
   Event.Data.FD := Server_Sock;

   Return_Value := Epoll.Control (EpollFD, Epoll.Epoll_Ctl_Add, To_C (Server_Sock), Event'Access);

   Log.Log_Message (Alog.Info, "mozzinid online and ready for work..");

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

               if Return_Value /= 0 then
                  Log.Log_Message (Alog.Error, "Failed to add a file descriptor to the Epoll descriptor");
               else
                  Mozzoni.Client.Register_Client (Client_Socket);
                  Log.Log_Message (Alog.Debug, "accepted..." & Integer'Image (To_C (Client_Socket)));
               end if;

            else
               declare
               begin
                  Log.Log_Message (Alog.Debug, "read event for: " & Integer'Image (To_C (Polled_Event.Data.FD)));
                  Log.Log_Message (Alog.Debug, "Event type: " & Epoll.Epoll_Events_Type'Image (Polled_Event.Events));

                  Client := Mozzoni.Client.Client_For (Polled_Event.Data.FD);
                  Client.Read_Available (Polled_Event.Data.FD);
               exception
                  when Err : others =>
                     Log.Log_Message (Alog.Error, Ada.Exceptions.Exception_Message(Err));
               end;

            end if;
         end;
      end loop;
   end loop;

end Main;
