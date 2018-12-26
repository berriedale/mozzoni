--
-- Mozzoni is a safe, multi-core capable NoSQL data service


with Ada.Exceptions;
with Ada.Streams;
with Ada.Text_IO;
with Alog;
with Epoll;
with Interfaces.C;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

with Mozzoni.Command_Loader;
with Mozzoni.Client;

with Mozzoni; use Mozzoni;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;

with Ada.Command_Line;


procedure Main is
   use type Interfaces.Unsigned_32;
   Server_Sock, Client_Socket : Socket_Type;
   Server_Addr : Sock_Addr_Type;

   EpollFD     : Epoll.Epoll_Fd_Type;
   Event       : aliased Epoll.Event_Type;
   Events      : Epoll.Event_Array_Type (1 .. 1);
   Return_Value, Descriptors : Integer;
   Socket_Request : Request_Type := (Non_Blocking_IO, True);
   Should_Exit : Boolean := False;

   task Standard_Input;

   task body Standard_Input is
      use Ada.Command_Line;
      use Ada.Text_IO;

      Ch : Character;
   begin
      Log.Log_Message (Alog.Info, ">> Press 'q' at any time to exit..");

      while Should_Exit = False loop
         Get (Ch);
         case Ch is
            when 'q' =>
               Should_Exit := True;

            when 's' =>

               Mozzoni.Client.Dump_Status;

            when others => null;
         end case;

      end loop;
   end Standard_Input;

begin
   Mozzoni.Command_Loader.Load;

   -- Initialize GNAT.Sockets
   Initialize;
   Server_Addr.Port := Port_Type (Mozzoni.Port);
   Server_Addr.Addr := Inet_Addr (Mozzoni.Default_Bind);

   Create_Socket (Server_Sock);
   Set_Socket_Option (Server_Sock, Socket_Level, (Reuse_Address, True));

   Bind_Socket (Server_Sock, Server_Addr);
   Listen_Socket (Server_Sock);
   EpollFD := Epoll.Create (Events'Length);

   if EpollFD = -1 then
      Log.Log_Message (Alog.Error, "Failed to create epoll(7) file descriptor");
      return;
   end if;

   Event.Events := Epoll.EPOLLIN or Epoll.EPOLLET;
   Event.Data.FD := Server_Sock;

   Return_Value := Epoll.Control (EpollFD, Epoll.Epoll_Ctl_Add, To_C (Server_Sock), Event'Access);

   Log.Log_Message (Alog.Info, "mozzinid online and ready for work..");
   Log.Log_Message (Alog.Info, "epoll descriptor" & Integer'Image (EpollFD));
   Log.Log_Message (Alog.Info, "server sock" & Integer'Image (To_C (Server_Sock)));

   loop
      if Should_Exit then
         return;
      end if;

      Descriptors := 0;
      Descriptors := Epoll.Wait (EpollFD,
                                 Events,
                                 Events'Length,
                                 100);



      for Index in 1 .. Descriptors loop
         declare
            Polled_Event : Epoll.Event_Type := Events (Integer (Index));

            Disconnecting : constant Boolean :=
                              (Polled_Event.Events and Epoll.EPOLLHUP) > 0;
         begin

            if Polled_Event.Data.FD = Server_Sock then

               -- Accept the new connection
               Accept_Socket (Server_Sock, Client_Socket, Server_Addr);
               Control_Socket (Client_Socket, Socket_Request);

               Event.Events := Epoll.EPOLLIN or Epoll.EPOLLET;
               Event.Data.FD := Client_Socket;

               Return_Value := Epoll.Control (EpollFD,
                                              Epoll.Epoll_Ctl_Add,
                                              To_C (Client_Socket),
                                              Event'Access);

               if Return_Value /= 0 then
                  raise Constraint_Error with "Failed to add descriptor";
               else
                  Mozzoni.Client.Register_Client (Client_Socket);
                  Log.Log_Message (Alog.Info, "accepted..." & Integer'Image (To_C (Client_Socket)));
               end if;

            elsif Disconnecting then
               Return_Value := Epoll.Control (EpollFD,
                                              Epoll.Epoll_Ctl_Del,
                                              To_C (Polled_Event.Data.FD),
                                              null);

               if Return_Value > 0 then
                  Log.Log_Message (Alog.Error,
                                   "A failure occurred trying to remove the descriptor from epoll(7)");
               end if;

               Mozzoni.Client.Deregister_Client (Polled_Event.Data.FD);

            elsif (Polled_Event.Events and Epoll.EPOLLIN) > 0 then

               declare
                  Client : Mozzoni.Client.Client_Type := Mozzoni.Client.Client_For (Polled_Event.Data.FD);
               begin
                  CLient.Read_Available (Polled_Event.Data.FD);
               exception
                  when Err : others =>
                     Log.Log_Message (Alog.Error, Ada.Exceptions.Exception_Message (Err));
                     raise;
               end;

            else
               Log.Log_Message (Alog.Error,
                                "Unhandled event type from the event loop:" & Polled_Event.Events'Img);
            end if;
         end;
      end loop;
   end loop;
end Main;
