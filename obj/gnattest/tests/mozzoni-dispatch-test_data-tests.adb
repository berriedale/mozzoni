--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Mozzoni.Dispatch.Test_Data.

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
package body Mozzoni.Dispatch.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Dispatch_Command (Gnattest_T : in out Test);
   procedure Test_Dispatch_Command_634e41 (Gnattest_T : in out Test) renames Test_Dispatch_Command;
--  id:2.2/634e4159f6b5efb6/Dispatch_Command/1/0/
   procedure Test_Dispatch_Command (Gnattest_T : in out Test) is
   --  mozzoni-dispatch.ads:15:4:Dispatch_Command
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Dispatch_Command;
--  end read only


--  begin read only
   procedure Test_Register_Command (Gnattest_T : in out Test);
   procedure Test_Register_Command_da40d5 (Gnattest_T : in out Test) renames Test_Register_Command;
--  id:2.2/da40d55978ced51c/Register_Command/1/0/
   procedure Test_Register_Command (Gnattest_T : in out Test) is
   --  mozzoni-dispatch.ads:21:4:Register_Command
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Register_Command;
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
end Mozzoni.Dispatch.Test_Data.Tests;
