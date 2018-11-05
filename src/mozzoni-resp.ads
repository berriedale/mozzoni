
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Mozzoni.Resp is

   type Any_Resp_Type is tagged
      record
         Parsed : Boolean := False;
      end record;
   -- The Any_Resp_Type is the root tagged record for all RESP types necessary
   -- for Mozzoni to parse or construct commands.
   
   type String_Resp_Type is new Any_Resp_Type with
      record
         Data : Unbounded_String;
      end record;
   -- The String_Resp_Rype abstracts the RESP Simple String type
   
   type Error_Resp_Type is new Any_Resp_Type with null record;
   
   type Integer_Resp_Type is new Any_Resp_Type with
      record
         Data : Integer;
      end record;
   
   type Bulk_String_Resp_Type is new String_Resp_Type with null record;
   -- TODO: Implement
   
   type Array_Resp_Type is new Any_Resp_Type with null record;
   -- TODO: Implement   

end Mozzoni.Resp;
