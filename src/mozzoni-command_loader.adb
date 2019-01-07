
with Mozzoni.Commands;
with Mozzoni.Commands.Connection;
with Mozzoni.Commands.Keys;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;

package body Mozzoni.Command_Loader is

   procedure Load is
   begin
      Register_Command ("PING", Mozzoni.Commands.Connection.Handle_Ping'Access);
      Register_Command ("ECHO", Mozzoni.Commands.Connection.Handle_Echo'Access);
      Register_Command ("QUIT", Mozzoni.Commands.Connection.Handle_Quit'Access);

      -- Register the key related commands (e.g. SET, GET, etc)
      Register_Command ("SET", Mozzoni.Commands.Keys.Handle_Set'Access);
      Register_Command ("GET", Mozzoni.Commands.Keys.Handle_Get'Access);
      Register_Command ("EXISTS", Mozzoni.Commands.Keys.Handle_Exists'Access);
      Register_Command ("DEL", Mozzoni.Commands.Keys.Handle_Del'Access);
   end Load;

end Mozzoni.Command_Loader;
