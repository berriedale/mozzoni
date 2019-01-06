--
-- Mozzoni is a safe, multi-core capable NoSQL data service

with Ada.Command_Line;
with Ada.Exceptions;
with Ada.Streams;
with Ada.Text_IO;
with Async.Raw.Epoll;
with Interfaces.C;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

with Mozzoni.Command_Loader;
with Mozzoni.Client;

with Mozzoni; use Mozzoni;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;


procedure Main is
   use Async.Raw.Epoll;

   use type Interfaces.Unsigned_32;
   Server_Sock : Socket_Type;
   Server_Addr : Sock_Addr_Type;

   EpollFD     : Epoll_Fd_Type;
   Server_Event       :  aliased Event_Type;
   Events      : Event_Array_Type (1 .. 32);
   Return_Value, Descriptors : Integer;
   Socket_Request : Request_Type := (Non_Blocking_IO, True);
   Should_Exit : Boolean := False;

   task Standard_Input;

   task body Standard_Input is
      use Ada.Command_Line;
      use Ada.Text_IO;

      Ch : Character;
   begin
      Log.Info (">> Press 'q' at any time to exit..");

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

   procedure Add_To_Epoll (efd : Epoll_Fd_Type;
                           Client_Socket : in Socket_Type) is

      Event       : aliased Event_Type;
      Call_Status : Integer;
      Socket : constant Integer := To_C (Client_Socket);




   begin
      Event.Events := EPOLLIN or EPOLLRDHUP;
      Event.Data.FD := Socket;

      Call_Status := Control (efd,
                                    Epoll_Ctl_Add,
                                    Socket,
                                    Event'Access);

      if Call_Status /= 0 then
         raise Constraint_Error with "Failed to add descriptor";
      end if;

   end Add_To_Epoll;


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

   -- Since Linux 2.6.8, the size argument is ignored, but must be greater than zero;
   EpollFD := Create (1);

   if EpollFD = -1 then
      Log.Error ("Failed to create epoll(7) file descriptor");
      return;
   end if;

   Server_Event.Events := EPOLLIN or EPOLLRDHUP;
   Server_Event.Data.FD := To_C (Server_Sock);

   Return_Value := Control (EpollFD, Epoll_Ctl_Add, To_C (Server_Sock), Server_Event'Access);

   Log.Info ("mozzoni-daemon online and ready for work..");
   Log.Debug ("Epoll descriptor: {1}", (1 => Log.d (EpollFD)));
   Log.Debug ("Server socket: {1}" , (1 => Log.d (To_C (Server_Sock))));

   loop
      if Should_Exit then
         return;
      end if;

      Descriptors := 0;
      Descriptors := Wait (EpollFD,
                                 Events,
                                 Events'Length,
                                 100);


      for Index in 1 .. Descriptors loop
         declare
            Polled_Event : Event_Type := Events (Integer (Index));

            Disconnecting : constant Boolean :=
                              (Polled_Event.Events and (EPOLLHUP or EPOLLRDHUP)) > 0;
            Client_Socket : Socket_Type;
         begin

            if Polled_Event.Data.FD = To_C (Server_Sock) then

               -- Accept the new connection
               Accept_Socket (Server_Sock, Client_Socket, Server_Addr);
               Control_Socket (Client_Socket, Socket_Request);

               Add_To_Epoll (EpollFD, Client_Socket);
               Mozzoni.Client.Register_Client (Client_Socket);
               Log.Debug ("Accepting a connection on fd {1}", (1 => Log.d (To_C (Client_Socket))));

            elsif (Polled_Event.Events and EPOLLIN) > 0 then

               declare
                  S : constant Socket_Type := To_Ada (Polled_Event.Data.FD);
                  Client : Mozzoni.Client.Client_Type := Mozzoni.Client.Client_For (S);
               begin
                  Client.Read_Available;

                  if Disconnecting then
                     Log.Debug ("Disconncting connection on fd {1}", (1 => Log.d (Polled_Event.Data.FD)));
                     Mozzoni.Client.Deregister_Client (S);
                  end if;

               exception
                  when Err : others =>
                     Log.Error (Ada.Exceptions.Exception_Message (Err));
                     raise;
               end;

            elsif Disconnecting then
               Return_Value := Control (EpollFD,
                                              Epoll_Ctl_Del,
                                              Polled_Event.Data.FD,
                                              null);

               if Return_Value > 0 then
                  Log.Error ("A failure occurred trying to remove the descriptor from epoll(7)");
               end if;

               Mozzoni.Client.Deregister_Client (To_Ada (Polled_Event.Data.FD));

            else
               Log.Error ("Unhandled event type from the event loop:" & Polled_Event.Events'Img);
            end if;
         end;
      end loop;
   end loop;
end Main;
