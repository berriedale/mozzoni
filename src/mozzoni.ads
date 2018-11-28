
with GNAT.Sockets;
with Interfaces.C;
with System;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Mozzoni is

   Port             : constant Natural := 6379;
   Default_Bind     : constant String := "127.0.0.1";


   type RESP_Type is (None, Human_Readable, Simple_String, Error, Int, Bulk, List);

   type Command_Item is record
      Item_Type : RESP_Type;
      Value     : Unbounded_String;
   end record;
   type Command_Array is array (Positive range <>) of Command_Item;
   type Command_Array_Access is access all Command_Array;

   -- Output the specified command to standard output
   procedure Print (Command : in Command_Array_Access)
     with Pre => Command /= null;


   function Read_Socket (S : in GNAT.Sockets.Socket_Type;
                         Buffer : in System.Address;
                         Count  : Interfaces.C.size_t) return Interfaces.C.size_t
     with Import,
       Link_Name => "read",
     Convention => C;

   function Error_Number return Integer
     with Import,
     Link_Name => "fetch_errno",
     Convention => C;


end Mozzoni;
