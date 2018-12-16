


with Ada.Text_IO; use Ada.Text_IO;

with Ada.Calendar;
with Ada.Strings.Unbounded.Hash;
with Ada.Characters.Latin_1;

with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Ada.Text_IO; use Ada.Text_IO;

package body Mozzoni.Commands.Keys is

   No_Expiry : constant Ada.Calendar.Time := Ada.Calendar.Time_Of (1970, 1, 1);

   type Value_Type is record
      Buffer : Unbounded_String;
      Expiry : Ada.Calendar.Time := No_Expiry;
   end record;

   package Hashed_Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Unbounded_String,
                                                          Element_Type    => Value_Type,
                                                          Hash            => Ada.Strings.Unbounded.Hash,
                                                          Equivalent_Keys => "=");
   Keys : Hashed_Maps.Map;

   -- Set a given value to the specified cache key
   --
   -- The positionals should be:
   --    - SET
   --    - <cachekey>
   --    - <value>
   procedure Handle_Set  (Client : in out Client_Type;
                          Command : Command_Array_Access) is
      use type Ada.Calendar.Time;

      Key_Item : Command_Item := Command (2);
      Buffer : Unbounded_String := Command (3).Value;
      Value_Item : Value_Type;
      Foo : Float := 1.0;
   begin
      Value_Item.Buffer := Buffer;

      if Command'Length > 5 then
         if Command (4).Value = "EX" then
            Value_Item.Expiry := Ada.Calendar.Clock + 1.0; -- Float'Value (To_String (Command (5).Value));
         end if;
      end if;

      Put_Line ("Handle_Set");
      if Hashed_Maps.Contains (Keys, Key_Item.Value) then
         Hashed_Maps.Replace (Keys, Key_Item.Value, Value_Item);
      else
         Hashed_Maps.Insert (Keys, Key_Item.Value, Value_Item);
      end if;

      Client.Write (Prepare_Response ("+OK"));
   end Handle_Set;


   procedure Handle_Get (Client : in out Client_Type;
                         Command : Command_Array_Access) is
      use Ada.Characters.Latin_1;
      use type Ada.Calendar.Time;

      Key_Item : Command_Item := Command (2);
      Cached_Value : Value_Type := Hashed_Maps.Element (Keys, Key_Item.Value);
   begin
      Put_Line ("Handle_Get");
      Client.Write ('$');

      if Cached_Value.Expiry /= No_Expiry then
         if Cached_Value.Expiry < Ada.Calendar.Clock then
            Client.Write (Prepare_Response ("-1"));
            return;
         end if;
      end if;

      Client.Write (Length (Cached_Value.Buffer));
      Client.Write (CR & LF);
      Client.Write (Prepare_Response (Cached_Value.Buffer));
   end Handle_Get;

end Mozzoni.Commands.Keys;
