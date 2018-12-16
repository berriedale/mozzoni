--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Mozzoni.Test_Data.

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
package body Mozzoni.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Print (Gnattest_T : in out Test);
   procedure Test_Print_76b074 (Gnattest_T : in out Test) renames Test_Print;
--  id:2.2/76b0749ca70fd84d/Print/1/0/
   procedure Test_Print (Gnattest_T : in out Test) is
   --  mozzoni.ads:23:4:Print
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Print;
--  end read only


--  begin read only
   procedure Test_Error_Number (Gnattest_T : in out Test);
   procedure Test_Error_Number_8c9266 (Gnattest_T : in out Test) renames Test_Error_Number;
--  id:2.2/8c926657c95c4d1a/Error_Number/1/0/
   procedure Test_Error_Number (Gnattest_T : in out Test) is
   --  mozzoni.ads:27:4:Error_Number
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Error_Number;
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
end Mozzoni.Test_Data.Tests;
