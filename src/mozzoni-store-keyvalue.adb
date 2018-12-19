
with Ada.Calendar;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Mozzoni.Store.KeyValue is

   function Is_Valid_Key (Key : in Key_Type) return Boolean is
   begin
      return Length (Key) > 0;
   end Is_Valid_Key;


   function Exists (Key : in Key_Type) return Boolean is
   begin
      if Is_Expired (Key) then
         return False;
      end if;

      return Hashed_Maps.Contains (Store, Key);
   end Exists;


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


   function Set (Key : in Key_Type; Value : in Value_Type) return Boolean is
   begin
      if Hashed_Maps.Contains (Store, Key) then
         Hashed_Maps.Replace (Store, Key, Value);
      else
         Hashed_Maps.Insert (Store, Key, Value);
      end if;
      return True;
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

end Mozzoni.Store.KeyValue;
