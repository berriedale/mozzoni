
package body Mozzoni.Store is

   function Is_Valid_Key (Key : in Key_Type) return Boolean is
   begin
      return Length (Key) > 0;
   end Is_Valid_Key;

   protected body KeyValue is

      function Exists (Key : in Key_Type) return Boolean is
      begin
         if Hashed_Maps.Contains (Store, Key) then
            if Is_Expired (Key) then
               return False;
            else
               return True;
            end if;
         end if;
         return False;
      end Exists;


      function Remove (Key : in Key_Type) return Boolean is
      -- Need a variable since Delete is an `in out` operation
         KV : Hashed_Maps.Map := Store;
      begin
         if not Hashed_Maps.Contains (KV, Key) then
            return False;
         end if;

         Hashed_Maps.Delete (KV, Key);
         return True;
      end Remove;


      function Is_Expired (Key : in Key_Type) return Boolean is
         Value : constant Value_Type := Hashed_Maps.Element (Store, Key);
         Now   : constant Ada.Calendar.Time := Ada.Calendar.Clock;

         use type Ada.Calendar.Time;
      begin
         if Value.Expiration = No_Expiry then
            return False;
         end if;

         return Value.Expiration < Now;
      end Is_Expired;


      procedure Set (Key : in Key_Type; Value : in Value_Type) is
      begin
         if Hashed_Maps.Contains (Store, Key) then
            Hashed_Maps.Replace (Store, Key, Value);
         else
            Hashed_Maps.Insert (Store, Key, Value);
         end if;
      end Set;


      function Get (Key : in Key_Type) return Value_Type is
      begin
         if Is_Expired (Key) then
            return No_Value;
         end if;

         return Hashed_Maps.Element (Store, Key);
      end Get;


      procedure Flush is
      begin
         Hashed_Maps.Clear (Store);
      end Flush;

   end KeyValue;

end Mozzoni.Store;
