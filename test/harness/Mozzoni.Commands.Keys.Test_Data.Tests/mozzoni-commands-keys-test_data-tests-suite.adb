--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Test_Caller;
with Gnattest_Generated;

package body Mozzoni.Commands.Keys.Test_Data.Tests.Suite is

   package Runner_1 is new AUnit.Test_Caller
     (GNATtest_Generated.GNATtest_Standard.Mozzoni.Commands.Keys.Test_Data.Tests.Test);

   Result : aliased AUnit.Test_Suites.Test_Suite;

   Case_1_1_Test_Handle_Set_2998b1 : aliased Runner_1.Test_Case;
   Case_2_1_Test_Handle_Get_c67e84 : aliased Runner_1.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin

      Runner_1.Create
        (Case_1_1_Test_Handle_Set_2998b1,
         "mozzoni-commands-keys.ads:8:4:",
         Test_Handle_Set_2998b1'Access);
      Runner_1.Create
        (Case_2_1_Test_Handle_Get_c67e84,
         "mozzoni-commands-keys.ads:12:4:",
         Test_Handle_Get_c67e84'Access);

      Result.Add_Test (Case_1_1_Test_Handle_Set_2998b1'Access);
      Result.Add_Test (Case_2_1_Test_Handle_Get_c67e84'Access);

      return Result'Access;

   end Suite;

end Mozzoni.Commands.Keys.Test_Data.Tests.Suite;
--  end read only
