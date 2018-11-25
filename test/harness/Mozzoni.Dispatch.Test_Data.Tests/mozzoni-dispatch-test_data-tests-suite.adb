--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Test_Caller;
with Gnattest_Generated;

package body Mozzoni.Dispatch.Test_Data.Tests.Suite is

   package Runner_1 is new AUnit.Test_Caller
     (GNATtest_Generated.GNATtest_Standard.Mozzoni.Dispatch.Test_Data.Tests.Test);

   Result : aliased AUnit.Test_Suites.Test_Suite;

   Case_1_1_Test_Dispatch_Command_d94ce7 : aliased Runner_1.Test_Case;
   Case_2_1_Test_Register_Command_da40d5 : aliased Runner_1.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin

      Runner_1.Create
        (Case_1_1_Test_Dispatch_Command_d94ce7,
         "mozzoni-dispatch.ads:13:4:",
         Test_Dispatch_Command_d94ce7'Access);
      Runner_1.Create
        (Case_2_1_Test_Register_Command_da40d5,
         "mozzoni-dispatch.ads:17:4:",
         Test_Register_Command_da40d5'Access);

      Result.Add_Test (Case_1_1_Test_Dispatch_Command_d94ce7'Access);
      Result.Add_Test (Case_2_1_Test_Register_Command_da40d5'Access);

      return Result'Access;

   end Suite;

end Mozzoni.Dispatch.Test_Data.Tests.Suite;
--  end read only
