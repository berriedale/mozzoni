--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Test_Suites; use AUnit.Test_Suites;
with Gnattest_Generated;
with AUnit.Reporter.GNATtest;
with AUnit.Run;
with AUnit.Options; use AUnit.Options;
procedure Mozzoni.Command_Loader.Test_Data.Tests.Suite.Test_Runner is

   procedure Runner is new AUnit.Run.Test_Runner (Suite);
   Reporter : AUnit.Reporter.GNATtest.GNATtest_Reporter;
   GT_Options : AUnit_Options := Default_Options;

begin
   GT_Options.Report_Successes := True;

   Runner (Reporter, GT_Options);
end Mozzoni.Command_Loader.Test_Data.Tests.Suite.Test_Runner;
--  end read only
