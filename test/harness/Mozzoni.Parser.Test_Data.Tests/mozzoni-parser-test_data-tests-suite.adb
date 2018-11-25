--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Test_Caller;
with Gnattest_Generated;

package body Mozzoni.Parser.Test_Data.Tests.Suite is

   package Runner_1 is new AUnit.Test_Caller
     (GNATtest_Generated.GNATtest_Standard.Mozzoni.Parser.Test_Data.Tests.Test);

   Result : aliased AUnit.Test_Suites.Test_Suite;

   Case_1_1_Test_Convert_Byte_a0e4d9 : aliased Runner_1.Test_Case;
   Case_2_1_Test_Read_To_CRLF_36d02c : aliased Runner_1.Test_Case;
   Case_3_1_Test_Read_Bulk_8bfaf7 : aliased Runner_1.Test_Case;
   Case_4_1_Test_Read_Item_e4127d : aliased Runner_1.Test_Case;
   Case_5_1_Test_Read_Command_List_bb6902 : aliased Runner_1.Test_Case;
   Case_6_1_Test_Parse_Human_Readable_Command_364d20 : aliased Runner_1.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin

      Runner_1.Create
        (Case_1_1_Test_Convert_Byte_a0e4d9,
         "mozzoni-parser.ads:18:4:",
         Test_Convert_Byte_a0e4d9'Access);
      Runner_1.Create
        (Case_2_1_Test_Read_To_CRLF_36d02c,
         "mozzoni-parser.ads:25:4:",
         Test_Read_To_CRLF_36d02c'Access);
      Runner_1.Create
        (Case_3_1_Test_Read_Bulk_8bfaf7,
         "mozzoni-parser.ads:31:4:",
         Test_Read_Bulk_8bfaf7'Access);
      Runner_1.Create
        (Case_4_1_Test_Read_Item_e4127d,
         "mozzoni-parser.ads:39:4:",
         Test_Read_Item_e4127d'Access);
      Runner_1.Create
        (Case_5_1_Test_Read_Command_List_bb6902,
         "mozzoni-parser.ads:45:4:",
         Test_Read_Command_List_bb6902'Access);
      Runner_1.Create
        (Case_6_1_Test_Parse_Human_Readable_Command_364d20,
         "mozzoni-parser.ads:50:4:",
         Test_Parse_Human_Readable_Command_364d20'Access);

      Result.Add_Test (Case_1_1_Test_Convert_Byte_a0e4d9'Access);
      Result.Add_Test (Case_2_1_Test_Read_To_CRLF_36d02c'Access);
      Result.Add_Test (Case_3_1_Test_Read_Bulk_8bfaf7'Access);
      Result.Add_Test (Case_4_1_Test_Read_Item_e4127d'Access);
      Result.Add_Test (Case_5_1_Test_Read_Command_List_bb6902'Access);
      Result.Add_Test (Case_6_1_Test_Parse_Human_Readable_Command_364d20'Access);

      return Result'Access;

   end Suite;

end Mozzoni.Parser.Test_Data.Tests.Suite;
--  end read only
