
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package body Mozzoni.Commands is

   function Prepare_Response (Value : String) return String is
   begin
      return Value & CR & LF;
   end Prepare_Response;


   procedure Handle_Ping (Channel : in Stream_Access;
                          Command : Command_Array_Access) is
   begin
      String'Write (Channel, Prepare_Response ("+PONG"));
   end Handle_Ping;

end Mozzoni.Commands;
