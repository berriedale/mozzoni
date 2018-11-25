

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

package Mozzoni.Commands.Keys is

      procedure Handle_Set  (Channel : in Stream_Access;
                             Command : Command_Array_Access)
        with Pre => Channel /= null and Command /= null;


end Mozzoni.Commands.Keys;
