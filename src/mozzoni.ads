
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Logga;

package Mozzoni is

   Port             : constant Natural := 6379;
   Default_Bind     : constant String := "127.0.0.1";

   Log : constant Logga.Log_Type := (Level  => Logga.Info,
                                     Colors => True);

   type RESP_Type is (None, Human_Readable, Simple_String, Error, Int, Bulk, List);

   type Command_Item is record
      Item_Type : RESP_Type;
      Value     : Unbounded_String;
   end record;
   type Command_Array is array (Positive range <>) of Command_Item;
   type Command_Array_Access is access all Command_Array;

   function Error_Number return Integer
     with Import,
     Link_Name => "fetch_errno",
     Convention => C;

end Mozzoni;
