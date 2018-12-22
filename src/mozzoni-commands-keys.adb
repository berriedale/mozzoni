
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

      -- Set_Options is a helpful little structure for processing the options
      -- sent on a SET request.
      type Set_Options is record
         If_Exists : Boolean := False;
         If_Not_Exists : Boolean := False;
         Expire_Seconds : Duration := 0.0;
         Expire_Milliseconds : Duration := 0.0;
      end record;

      function Process_Options (C : Command_Array_Access) return Set_Options is
         Options : Set_Options;
         Previous_Value : Unbounded_String := Null_Unbounded_String;
      begin
         if C'Length = 4 then
            -- Standard SET invocation with no options, return early
            return Options;
         end if;

         -- Read the rest of the items in the Command for the potential values
         for Item of C (4 .. C'Length) loop
            if Item.Value = "NX" then
               Options.If_Not_Exists := True;
            elsif Item.Value = "XX" then
               Options.If_Exists := True;
            else
               null;
            end if;

            if "EX" = Previous_Value then
               Options.Expire_Seconds := Duration'Value (To_String (Item.Value));
            elsif "PX" = Previous_Value then
               Options.Expire_Milliseconds := Duration'Value (To_String (Item.Value)) / 1000.0;
            end if;

            Previous_Value := Item.Value;
         end loop;
         return Options;
      end Process_Options;

      Options : constant Set_Options := Process_Options (Command);
      Now     : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      Exists  : constant Boolean := KeyValue.Exists (Key_Item.Value);
   begin
      Value_Item.Buffer := Buffer;

      Log.Log_Message (Alog.Warning,
                               "Commands length: " & Integer'Image (Command'Length));

      if Options.Expire_Seconds > 0.0 then
         Value_Item.Expiration := Now + Options.Expire_Seconds;
      elsif Options.Expire_Milliseconds > 0.0 then
         Value_Item.Expiration := Now + Options.Expire_Milliseconds;
      end if;

      if Options.If_Not_Exists and Exists then
         -- Return a bulk string null response if we cannot set this value
         Client.Write (Prepare_Response ("$-1"));
         return;
      end if;

      if Options.If_Exists and not Exists then
         -- Return a bulk string null response if we cannot set this value
         Client.Write (Prepare_Response ("$-1"));
         return;
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

      if KeyValue.Exists (Key) = False then
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
