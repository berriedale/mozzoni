

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Mozzoni.Client; use Mozzoni.Client;

package Mozzoni.Commands.Keys is

   procedure Handle_Set  (Client  : in out Client_Type;
                          Command : Command_Array_Access)
     with Pre => Client.Is_Valid and Command /= null;

   procedure Handle_Get (Client  : in out Client_Type;
                         Command : Command_Array_Access)
     with Pre => Client.Is_Valid and Command /= null;

   procedure Handle_Exists (Client  : in out Client_Type;
                            Command : Command_Array_Access)
     with Pre => Client.Is_Valid and Command /= null;

end Mozzoni.Commands.Keys;
