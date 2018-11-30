
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package body Mozzoni.Commands is

   function Prepare_Response (Value : String) return String is
   begin
      return Value & CR & LF;
   end Prepare_Response;


   procedure Handle_Ping (Client : in out Client_Type;
                          Command : Command_Array_Access) is
   begin
      Client.Write (Prepare_Response ("+PONG"));
   end Handle_Ping;

end Mozzoni.Commands;
