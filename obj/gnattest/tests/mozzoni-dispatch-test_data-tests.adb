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

   Dispatchable_Called : Natural := 0;

   procedure Dispatchable (C : in out Client_Type;
                           CA : in Command_Array_Access) is
   begin
      Dispatchable_Called := Dispatchable_Called + 1;
   end Dispatchable;

--  begin read only
--  end read only

--  begin read only
   procedure Test_Is_Registered (Gnattest_T : in out Test);
   procedure Test_Is_Registered_79ddeb (Gnattest_T : in out Test) renames Test_Is_Registered;
--  id:2.2/79ddebb2d439888d/Is_Registered/1/0/
   procedure Test_Is_Registered (Gnattest_T : in out Test) is
   --  mozzoni-dispatch.ads:15:4:Is_Registered
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (Is_Registered ("this should never exist") = False,
                               "Failed to validate registration of non-existent command");

--  begin read only
   end Test_Is_Registered;
--  end read only


--  begin read only
   procedure Test_Dispatch_Command (Gnattest_T : in out Test);
   procedure Test_Dispatch_Command_634e41 (Gnattest_T : in out Test) renames Test_Dispatch_Command;
--  id:2.2/634e4159f6b5efb6/Dispatch_Command/1/0/
   procedure Test_Dispatch_Command (Gnattest_T : in out Test) is
   --  mozzoni-dispatch.ads:18:4:Dispatch_Command
--  end read only

      pragma Unreferenced (Gnattest_T);

      Name : constant String := "dispatch-gnattest";
      Client : Client_Type;
      Command : Command_Array_Access := new Command_Array (1 .. 1);

   begin
      Command (1) := (Simple_String, To_Unbounded_String (Name));

      Register_Command (Name, Dispatchable'Access);
      Dispatch_Command (Client, Command);

      AUnit.Assertions.Assert (Dispatchable_Called > 0,
                               "The dispatchable callback does not appear to have been called");

--  begin read only
   end Test_Dispatch_Command;
--  end read only


--  begin read only
   procedure Test_Register_Command (Gnattest_T : in out Test);
   procedure Test_Register_Command_da40d5 (Gnattest_T : in out Test) renames Test_Register_Command;
--  id:2.2/da40d55978ced51c/Register_Command/1/0/
   procedure Test_Register_Command (Gnattest_T : in out Test) is
   --  mozzoni-dispatch.ads:24:4:Register_Command
--  end read only

      pragma Unreferenced (Gnattest_T);

      Name : constant String := "gnattest";
   begin

      Register_Command (Name, Dispatchable'Access);

      AUnit.Assertions.Assert (Is_Registered (Name),
                               "Unable to register a command callback properly");

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
