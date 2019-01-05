--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Mozzoni.Client.Test_Data.

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
package body Mozzoni.Client.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Has_Client (Gnattest_T : in out Test);
   procedure Test_Has_Client_08cb0c (Gnattest_T : in out Test) renames Test_Has_Client;
--  id:2.2/08cb0c23d0202b56/Has_Client/1/0/
   procedure Test_Has_Client (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:38:4:Has_Client
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Has_Client;
--  end read only


--  begin read only
   procedure Test_Register_Client (Gnattest_T : in out Test);
   procedure Test_Register_Client_54a4ba (Gnattest_T : in out Test) renames Test_Register_Client;
--  id:2.2/54a4ba3d8480e0fd/Register_Client/1/0/
   procedure Test_Register_Client (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:41:4:Register_Client
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Register_Client;
--  end read only


--  begin read only
   procedure Test_Deregister_Client (Gnattest_T : in out Test);
   procedure Test_Deregister_Client_cc045f (Gnattest_T : in out Test) renames Test_Deregister_Client;
--  id:2.2/cc045f6ce0713995/Deregister_Client/1/0/
   procedure Test_Deregister_Client (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:46:4:Deregister_Client
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Deregister_Client;
--  end read only


--  begin read only
   procedure Test_Dump_Status (Gnattest_T : in out Test);
   procedure Test_Dump_Status_ee75bc (Gnattest_T : in out Test) renames Test_Dump_Status;
--  id:2.2/ee75bcb86b376fe3/Dump_Status/1/0/
   procedure Test_Dump_Status (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:52:4:Dump_Status
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Dump_Status;
--  end read only


--  begin read only
   procedure Test_Hash_Descriptor (Gnattest_T : in out Test);
   procedure Test_Hash_Descriptor_c833a5 (Gnattest_T : in out Test) renames Test_Hash_Descriptor;
--  id:2.2/c833a53e886af8a2/Hash_Descriptor/1/0/
   procedure Test_Hash_Descriptor (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:57:4:Hash_Descriptor
--  end read only

      pragma Unreferenced (Gnattest_T);

      Hashed : constant Hash_Type := Hash_Descriptor (1337);

   begin

      AUnit.Assertions.Assert (Hashed > 0,
                               "Expected Hash_Descriptor to turn an Integer into a Hash");

--  begin read only
   end Test_Hash_Descriptor;
--  end read only


--  begin read only
   procedure Test_Read_Socket (Gnattest_T : in out Test);
   procedure Test_Read_Socket_609c7d (Gnattest_T : in out Test) renames Test_Read_Socket;
--  id:2.2/609c7ddfc531d340/Read_Socket/1/0/
   procedure Test_Read_Socket (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:69:4:Read_Socket
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- This is an imported function
      null;

--  begin read only
   end Test_Read_Socket;
--  end read only


--  begin read only
   procedure Test_Write_Socket (Gnattest_T : in out Test);
   procedure Test_Write_Socket_f63b4b (Gnattest_T : in out Test) renames Test_Write_Socket;
--  id:2.2/f63b4b647f6092f6/Write_Socket/1/0/
   procedure Test_Write_Socket (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:76:4:Write_Socket
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- This is an imported function
      null;

--  begin read only
   end Test_Write_Socket;
--  end read only


--  begin read only
   procedure Test_Close_Socket (Gnattest_T : in out Test);
   procedure Test_Close_Socket_73424d (Gnattest_T : in out Test) renames Test_Close_Socket;
--  id:2.2/73424da53916b082/Close_Socket/1/0/
   procedure Test_Close_Socket (Gnattest_T : in out Test) is
   --  mozzoni-client.ads:83:4:Close_Socket
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Close_Socket;
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
end Mozzoni.Client.Test_Data.Tests;
