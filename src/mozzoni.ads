
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Mozzoni is

   Port             : constant Natural := 6379;
   Default_Bind     : constant String := "127.0.0.1";
   Command_Name_Max : constant := 16;


   type RESP_Type is (None, Simple_String, Error, Int, Bulk, List);

   type Command_Item is record
      Item_Type : RESP_Type;
      Value     : Unbounded_String;
   end record;
   type Command_Array is array (Positive range <>) of Command_Item;
   type Command_Array_Access is access all Command_Array;

   -- Output the specified command to standard output
   procedure Print (Command : in Command_Array_Access)
     with Pre => Command /= null;

end Mozzoni;
