
with Ada.Text_IO; use Ada.Text_IO;

package body Mozzoni is

   procedure Print (Command : Command_Array_Access) is
   begin
      for Item of Command.all loop
         Put_Line (To_String (Item.Value));
      end loop;
   end Print;

end Mozzoni;
