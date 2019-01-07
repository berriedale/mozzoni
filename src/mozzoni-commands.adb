
with Ada.Characters.Latin_1;

package body Mozzoni.Commands is

   function Prepare_Response (Value : String) return String is
      use Ada.Characters.Latin_1;
   begin
      return Value & CR & LF;
   end Prepare_Response;

   function Prepare_Response (Value : in Unbounded_String) return String is
   begin
      return Prepare_Response (To_String (Value));
   end Prepare_Response;


end Mozzoni.Commands;
