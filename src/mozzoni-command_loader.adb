
with Mozzoni.Commands;
with Mozzoni.Commands.Keys;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;

package body Mozzoni.Command_Loader is

   procedure Load is
   begin
      Register_Command ("PING", Mozzoni.Commands.Handle_Ping'Access);

      -- Register the key related commands (e.g. SET, GET, etc)
      Register_Command ("SET", Mozzoni.Commands.Keys.Handle_Set'Access);
      Register_Command ("GET", Mozzoni.Commands.Keys.Handle_Get'Access);
   end Load;

end Mozzoni.Command_Loader;
