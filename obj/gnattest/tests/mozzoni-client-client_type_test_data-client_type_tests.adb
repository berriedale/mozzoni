--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Mozzoni.Client.Client_Type_Test_Data.

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
package body Mozzoni.Client.Client_Type_Test_Data.Client_Type_Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

   procedure Lookup_Invalid_Client_Int is
      C : constant Client_Type := Client_For (1337);
   begin
      null;
   end Lookup_Invalid_Client_Int;

   procedure Lookup_Invalid_Client_Socket is
      S : Socket_Type := No_Socket;
      C : constant Client_Type := Client_For (S);
   begin
      null;
   end Lookup_Invalid_Client_Socket;

--  begin read only
--  end read only

--  begin read only
   procedure Test_Is_Valid (Gnattest_T : in out Test_Client_Type);
   procedure Test_Is_Valid_ef2a98 (Gnattest_T : in out Test_Client_Type) renames Test_Is_Valid;
--  id:2.2/ef2a987f54e227e4/Is_Valid/1/0/
   procedure Test_Is_Valid (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:29:4:Is_Valid
--  end read only


      Valid : constant Boolean := Gnattest_T.Fixture.Is_Valid;

   begin

      AUnit.Assertions.Assert (Valid, "Expected the fixture to be a valid Client_Type");

--  begin read only
   end Test_Is_Valid;
--  end read only


--  begin read only
   procedure Test_Read_Available (Gnattest_T : in out Test_Client_Type);
   procedure Test_Read_Available_f8f154 (Gnattest_T : in out Test_Client_Type) renames Test_Read_Available;
--  id:2.2/f8f1540f1aba8e29/Read_Available/1/0/
   procedure Test_Read_Available (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:34:4:Read_Available
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- No-op due to the challenge of testing socket behavior in GNATtest
      null;

--  begin read only
   end Test_Read_Available;
--  end read only


--  begin read only
   procedure Test_1_Write (Gnattest_T : in out Test_Client_Type);
   procedure Test_Write_8c9d70 (Gnattest_T : in out Test_Client_Type) renames Test_1_Write;
--  id:2.2/8c9d7061edeeea0a/Write/1/0/
   procedure Test_1_Write (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:40:4:Write
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- no-op test case since we're just invoking underlying stream functionality
      null;

--  begin read only
   end Test_1_Write;
--  end read only


--  begin read only
   procedure Test_2_Write (Gnattest_T : in out Test_Client_Type);
   procedure Test_Write_1a9cb5 (Gnattest_T : in out Test_Client_Type) renames Test_2_Write;
--  id:2.2/1a9cb59ddb076acf/Write/0/0/
   procedure Test_2_Write (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:46:4:Write
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- no-op test case since we're just invoking underlying stream functionality
      null;

--  begin read only
   end Test_2_Write;
--  end read only


--  begin read only
   procedure Test_3_Write (Gnattest_T : in out Test_Client_Type);
   procedure Test_Write_7f6e4c (Gnattest_T : in out Test_Client_Type) renames Test_3_Write;
--  id:2.2/7f6e4cf27e1eb94b/Write/0/0/
   procedure Test_3_Write (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:56:4:Write
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- no-op test case since we're just invoking underlying stream functionality
      null;

--  begin read only
   end Test_3_Write;
--  end read only


--  begin read only
   procedure Test_Write_Line_Ending (Gnattest_T : in out Test_Client_Type);
   procedure Test_Write_Line_Ending_579bd3 (Gnattest_T : in out Test_Client_Type) renames Test_Write_Line_Ending;
--  id:2.2/579bd35a577c3831/Write_Line_Ending/1/0/
   procedure Test_Write_Line_Ending (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:60:4:Write_Line_Ending
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- no-op test case since we're just invoking underlying stream functionality
      null;

--  begin read only
   end Test_Write_Line_Ending;
--  end read only


--  begin read only
   procedure Test_1_Client_For (Gnattest_T : in out Test_Client_Type);
   procedure Test_Client_For_bc4703 (Gnattest_T : in out Test_Client_Type) renames Test_1_Client_For;
--  id:2.2/bc4703174166b521/Client_For/1/0/
   procedure Test_1_Client_For (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:89:4:Client_For
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin
      AUnit.Assertions.Assert_Exception (Lookup_Invalid_Client_Int'Access,
                                           "Expected an invalid Client lookup to throw a ConstraintError");

--  begin read only
   end Test_1_Client_For;
--  end read only


--  begin read only
   procedure Test_2_Client_For (Gnattest_T : in out Test_Client_Type);
   procedure Test_Client_For_280f2c (Gnattest_T : in out Test_Client_Type) renames Test_2_Client_For;
--  id:2.2/280f2c7eee8955be/Client_For/0/0/
   procedure Test_2_Client_For (Gnattest_T : in out Test_Client_Type) is
   --  mozzoni-client.ads:96:4:Client_For
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin
      AUnit.Assertions.Assert_Exception (Lookup_Invalid_Client_Socket'Access,
                                         "Expected an invalid Client lookup to throw a ConstraintError");


--  begin read only
   end Test_2_Client_For;
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
end Mozzoni.Client.Client_Type_Test_Data.Client_Type_Tests;
