
with Ada.Calendar;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Mozzoni.Store; use Mozzoni.Store;

package body Mozzoni.Commands.Keys is

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

      function Convert_To_Secs (Item : in Command_Item) return Duration is
      begin
         return Duration'Value (To_String (Item.Value));
      end Convert_To_Secs;

   begin
      Value_Item.Buffer := Buffer;

      if Command'Length > 5 then
         if Command (4).Value = "EX" then
            Value_Item.Expiration := Ada.Calendar.Clock + Convert_To_Secs (Command (5));
         end if;
      end if;

      KeyValue.Set (Key_Item.Value, Value_Item);

      Client.Write (Prepare_Response ("+OK"));
   end Handle_Set;


   procedure Handle_Get (Client : in out Client_Type;
                         Command : Command_Array_Access) is
      use Ada.Characters.Latin_1;

      Key_Item : Command_Item := Command (2);
      Key : constant Unbounded_String := Key_Item.Value;
   begin
      Client.Write ('$');

      if KeyValue.Is_Expired (Key) then
         Client.Write (Prepare_Response ("-1"));
         return;
      end if;

      declare
         Value : constant Value_Type :=  KeyValue.Get (Key);
      begin
         Client.Write (Length (Value.Buffer));
         Client.Write (CR & LF);
         Client.Write (Prepare_Response (Value.Buffer));
      end;

   end Handle_Get;

end Mozzoni.Commands.Keys;
