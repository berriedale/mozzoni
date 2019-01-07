package body Mozzoni.Commands.Connection is

   procedure Handle_Ping (Client  : in out Client_Type;
                          Command : Command_Array_Access) is
   begin
      Client.Write (Prepare_Response ("+PONG"));
   end Handle_Ping;


   procedure Handle_Echo (Client  : in out Client_Type;
                          Command : Command_Array_Access) is
      Payload : constant Command_Item := Command (2);
   begin
      Client.Write ('$');
      Client.Write (Length (Payload.Value));
      Client.Write_Line_Ending;
      Client.Write (To_String (Payload.Value));
      Client.Write_Line_Ending;
   end Handle_Echo;


   procedure Handle_Quit (Client  : in out Client_Type;
                          Command : Command_Array_Access) is
   begin
      Client.Write (Prepare_Response ("+OK"));
      raise Disconnect_Client with "Client requested QUIT";
   end Handle_Quit;


end Mozzoni.Commands.Connection;
