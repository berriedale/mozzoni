
with Mozzoni.Commands;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;

package body Mozzoni.Command_Loader is

   procedure Load is
   begin
      Register_Command ("PING", Mozzoni.Commands.Handle_Ping'Access);
   end Load;

end Mozzoni.Command_Loader;
