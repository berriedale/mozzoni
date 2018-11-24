package body Mozzoni.Commands is

   procedure Handle_Ping (Channel : in Stream_Access;
                          Command : Command_Array_Access) is
   begin
      String'Write (Channel, "+PONG");
   end Handle_Ping;

end Mozzoni.Commands;
