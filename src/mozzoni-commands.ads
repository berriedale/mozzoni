
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Mozzoni; use Mozzoni;
with Mozzoni.Client; use Mozzoni.Client;

package Mozzoni.Commands is

   function Prepare_Response (Value : in String) return String
     with Pre => Value'Length > 0;
   function Prepare_Response (Value : in Unbounded_String) return String
     with Pre => Length (Value) > 0;

end Mozzoni.Commands;
