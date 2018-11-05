with Mozzoni;

with Mozzoni.Resp; use Mozzoni.Resp;

package body Mozzoni.Parser is
   
   function Parse (Buffer : in Unbounded_String) return Any_Resp_Type'Class is
      Response : Any_Resp_Type;
   begin
      return Response;
   end Parse;

end Mozzoni.Parser;
