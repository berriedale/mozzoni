--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Mozzoni.Store.Test_Data.

with AUnit.Assertions; use AUnit.Assertions;
with System.Assertions;

--  begin read only
--  id:2.2/00/
--
--  This section can be used to add with clauses if necessary.
--
--  end read only

--  begin read only
--  end read only
package body Mozzoni.Store.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Is_Valid_Key (Gnattest_T : in out Test);
   procedure Test_Is_Valid_Key_31ba94 (Gnattest_T : in out Test) renames Test_Is_Valid_Key;
--  id:2.2/31ba94484d901b73/Is_Valid_Key/1/0/
   procedure Test_Is_Valid_Key (Gnattest_T : in out Test) is
   --  mozzoni-store.ads:49:4:Is_Valid_Key
--  end read only

      pragma Unreferenced (Gnattest_T);
      Valid : constant Unbounded_String := To_Unbounded_String ("gnattest");
      Invalid : constant Unbounded_String := Null_Unbounded_String;

   begin

      AUnit.Assertions.Assert (Is_Valid_Key (Valid), "Expected a valid Key_Type");
      AUnit.Assertions.Assert (Is_Valid_Key (Invalid) = False, "Expected an invalid Key_Type");

--  begin read only
   end Test_Is_Valid_Key;
--  end read only

--  begin read only
--  id:2.2/02/
--
--  This section can be used to add elaboration code for the global state.
--
begin
--  end read only
   null;
--  begin read only
--  end read only
end Mozzoni.Store.Test_Data.Tests;
