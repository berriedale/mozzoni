package body Mozzoni.Commands.Keys is


   procedure Handle_Set  (Channel : in Stream_Access;
                          Command : Command_Array_Access) is
   begin
      String'Write (Channel, Prepare_Response ("+OK"));
   end Handle_Set;

end Mozzoni.Commands.Keys;
