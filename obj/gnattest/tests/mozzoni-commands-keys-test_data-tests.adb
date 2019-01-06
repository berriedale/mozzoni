--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Mozzoni.Commands.Keys.Test_Data.

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
package body Mozzoni.Commands.Keys.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Handle_Set (Gnattest_T : in out Test);
   procedure Test_Handle_Set_c8c040 (Gnattest_T : in out Test) renames Test_Handle_Set;
--  id:2.2/c8c040d35ec28350/Handle_Set/1/0/
   procedure Test_Handle_Set (Gnattest_T : in out Test) is
   --  mozzoni-commands-keys.ads:8:4:Handle_Set
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- covered more effectively by acceptance tests at the moment
      null;

--  begin read only
   end Test_Handle_Set;
--  end read only


--  begin read only
   procedure Test_Handle_Get (Gnattest_T : in out Test);
   procedure Test_Handle_Get_6babbe (Gnattest_T : in out Test) renames Test_Handle_Get;
--  id:2.2/6babbe7e875aa36b/Handle_Get/1/0/
   procedure Test_Handle_Get (Gnattest_T : in out Test) is
   --  mozzoni-commands-keys.ads:12:4:Handle_Get
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- covered more effectively by acceptance tests at the moment
      null;

--  begin read only
   end Test_Handle_Get;
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
end Mozzoni.Commands.Keys.Test_Data.Tests;
