--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Mozzoni.Store.KeyValue.Test_Data.

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
package body Mozzoni.Store.KeyValue.Test_Data.Tests is

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
   --  mozzoni-store-keyvalue.ads:41:4:Is_Valid_Key
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
   procedure Test_Exists (Gnattest_T : in out Test);
   procedure Test_Exists_128b94 (Gnattest_T : in out Test) renames Test_Exists;
--  id:2.2/128b942adfb89988/Exists/1/0/
   procedure Test_Exists (Gnattest_T : in out Test) is
   --  mozzoni-store-keyvalue.ads:44:4:Exists
--  end read only

      pragma Unreferenced (Gnattest_T);
      Value : Value_Type := (Buffer     => To_Unbounded_String ("value"),
                             Expiration => No_Expiry);
      Key : constant Unbounded_String := To_Unbounded_String ("some-key");
      Was_Set : constant Boolean := Set (Key, Value);

   begin

      AUnit.Assertions.Assert (Exists (Key),
                               "Key should be considered to exist after Set");

--  begin read only
   end Test_Exists;
--  end read only


--  begin read only
   procedure Test_Is_Expired (Gnattest_T : in out Test);
   procedure Test_Is_Expired_1bbeb0 (Gnattest_T : in out Test) renames Test_Is_Expired;
--  id:2.2/1bbeb029a8bd65d9/Is_Expired/1/0/
   procedure Test_Is_Expired (Gnattest_T : in out Test) is
   --  mozzoni-store-keyvalue.ads:53:4:Is_Expired
--  end read only

      pragma Unreferenced (Gnattest_T);
      Value : Value_Type := (Buffer => To_Unbounded_String ("value"),
                                      Expiration => No_Expiry);
      Key : constant Unbounded_String := To_Unbounded_String ("some-key");

   begin

      AUNit.Assertions.Assert (Set (Key, Value),
                               "Unable to Set a valid key/value pair");

      Value.Buffer := To_Unbounded_String ("another value");
      AUnit.Assertions.Assert (Set (Key, Value),
                               "Unable to Set a replacement key/value pair");


--  begin read only
   end Test_Is_Expired;
--  end read only


--  begin read only
   procedure Test_Set (Gnattest_T : in out Test);
   procedure Test_Set_392ba2 (Gnattest_T : in out Test) renames Test_Set;
--  id:2.2/392ba262388fda53/Set/1/0/
   procedure Test_Set (Gnattest_T : in out Test) is
   --  mozzoni-store-keyvalue.ads:62:4:Set
--  end read only

      pragma Unreferenced (Gnattest_T);
      Value : Value_Type := (Buffer     => To_Unbounded_String ("value"),
                             Expiration => No_Expiry);
      Key : constant Unbounded_String := To_Unbounded_String ("some-key");

      Retrieved : Value_Type;
      Was_Set : constant Boolean := Set (Key, Value);

   begin

      AUnit.Assertions.Assert (Was_Set, "Should have been able to set a Key");

--  begin read only
   end Test_Set;
--  end read only


--  begin read only
   procedure Test_Get (Gnattest_T : in out Test);
   procedure Test_Get_8e97f4 (Gnattest_T : in out Test) renames Test_Get;
--  id:2.2/8e97f47f94d15b79/Get/1/0/
   procedure Test_Get (Gnattest_T : in out Test) is
   --  mozzoni-store-keyvalue.ads:76:4:Get
--  end read only

      pragma Unreferenced (Gnattest_T);
      Value : Value_Type := (Buffer     => To_Unbounded_String ("value"),
                             Expiration => No_Expiry);
      Key : constant Unbounded_String := To_Unbounded_String ("some-key");

      Retrieved : Value_Type;
      Was_Set : constant Boolean := Set (Key, Value);

   begin

      AUnit.Assertions.Assert (Was_Set, "Should have been able to Set a key first");

      Retrieved := Get (Key);

      AUnit.Assertions.Assert (Retrieved /= No_Value,
                               "Should have retrieved a Value properly");

--  begin read only
   end Test_Get;
--  end read only


--  begin read only
   procedure Test_Flush (Gnattest_T : in out Test);
   procedure Test_Flush_d9688c (Gnattest_T : in out Test) renames Test_Flush;
--  id:2.2/d9688ca04470f15a/Flush/1/0/
   procedure Test_Flush (Gnattest_T : in out Test) is
   --  mozzoni-store-keyvalue.ads:83:4:Flush
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Flush;
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
end Mozzoni.Store.KeyValue.Test_Data.Tests;
