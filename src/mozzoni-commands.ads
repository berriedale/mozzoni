
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Mozzoni; use Mozzoni;
with Mozzoni.Client; use Mozzoni.Client;

package Mozzoni.Commands is

   function Prepare_Response (Value : in String) return String
     with Pre => Value'Length > 0;
   function Prepare_Response (Value : in Unbounded_String) return String
     with Pre => Length (Value) > 0;

   procedure Handle_Ping (Client  : in out Client_Type;
                          Command : Command_Array_Access)
     with Pre => Client.Is_Valid and Command /= null;

end Mozzoni.Commands;
