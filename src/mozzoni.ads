
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Mozzoni is

   Port             : constant Natural := 6379;
   Default_Bind     : constant String := "127.0.0.1";
   Command_Name_Max : constant := 16;


   type RESP_Type is (None, Simple_String, Error, Int, Bulk, List);


   type RESP_Item (Kind : RESP_Type) is record
      Valid     : Boolean := False;
      Item_Type : RESP_Type := Kind;
      case Kind is
      when Simple_String =>
         Value  : Unbounded_String;
      when Int =>
         Number : Integer;
      when Bulk =>
         Buffer : Unbounded_String;
      when others => null;
      end case;
   end record;
   type RESP_Item_Access is access all RESP_Item;
   type RESP_Item_Array is array (Positive range <>) of RESP_Item_Access;

   type Command_Type (Max_Params : Natural) is record
      Name  : String (1 .. Command_Name_Max);
      Items : RESP_Item_Array (1 .. Max_Params);
   end record;
   type Command_Type_Access is access all Command_Type;

end Mozzoni;
