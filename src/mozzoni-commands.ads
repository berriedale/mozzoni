

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

with Mozzoni; use Mozzoni;

package Mozzoni.Commands is

   function Prepare_Response (Value : String) return String
     with Pre => Value'Length > 0;

   procedure Handle_Ping (Channel : in Stream_Access;
                          Command : Command_Array_Access)
     with Pre => Channel /= null and Command /= null;

end Mozzoni.Commands;
