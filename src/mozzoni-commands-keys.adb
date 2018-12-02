


with Ada.Text_IO; use Ada.Text_IO;

with Ada.Strings.Unbounded.Hash;
with Ada.Characters.Latin_1;

with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Ada.Text_IO; use Ada.Text_IO;

package body Mozzoni.Commands.Keys is

   package Hashed_Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Unbounded_String,
                                                         Element_Type    => Unbounded_String,
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
      Key_Item : Command_Item := Command (2);
      Value_Item : Command_Item := Command (3);
   begin
      Put_Line ("Handle_Set");
      if Hashed_Maps.Contains (Keys, Key_Item.Value) then
         Hashed_Maps.Replace (Keys, Key_Item.Value, Value_Item.Value);
      else
         Hashed_Maps.Insert (Keys, Key_Item.Value, Value_Item.Value);
      end if;

      Client.Write (Prepare_Response ("+OK"));
   end Handle_Set;


   procedure Handle_Get (Client : in out Client_Type;
                         Command : Command_Array_Access) is
      use Ada.Characters.Latin_1;
      Key_Item : Command_Item := Command (2);
      Cached_Value : Unbounded_String := Hashed_Maps.Element (Keys, Key_Item.Value);
   begin
      Put_Line ("Handle_Get");
      Client.Write ('$');
      Client.Write (Length (Cached_Value));
      Client.Write (CR & LF);
      Client.Write (Prepare_Response (Cached_Value));
   end Handle_Get;

end Mozzoni.Commands.Keys;
