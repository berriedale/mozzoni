--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Epoll.Test_Data.

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
package body Epoll.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Create (Gnattest_T : in out Test);
   procedure Test_Create_fa6782 (Gnattest_T : in out Test) renames Test_Create;
--  id:2.2/fa6782675541c8a5/Create/1/0/
   procedure Test_Create (Gnattest_T : in out Test) is
   --  epoll.ads:57:4:Create
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Create;
--  end read only


--  begin read only
   procedure Test_Control (Gnattest_T : in out Test);
   procedure Test_Control_0fba7e (Gnattest_T : in out Test) renames Test_Control;
--  id:2.2/0fba7e3637f75652/Control/1/0/
   procedure Test_Control (Gnattest_T : in out Test) is
   --  epoll.ads:62:5:Control
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Control;
--  end read only


--  begin read only
   procedure Test_Wait (Gnattest_T : in out Test);
   procedure Test_Wait_506aeb (Gnattest_T : in out Test) renames Test_Wait;
--  id:2.2/506aeb0bf6872092/Wait/1/0/
   procedure Test_Wait (Gnattest_T : in out Test) is
   --  epoll.ads:70:5:Wait
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Wait;
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
end Epoll.Test_Data.Tests;
