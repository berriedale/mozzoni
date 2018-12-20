
with Ada.Strings.Unbounded.Hash;
with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Mozzoni.Commands; use Mozzoni.Commands;

package body Mozzoni.Dispatch is

   package Dispatches is new Ada.Containers.Hashed_Maps (Key_Type        => Unbounded_String,
                                                         Element_Type    => Dispatchable_Type,
                                                         Hash            => Ada.Strings.Unbounded.Hash,
                                                         Equivalent_Keys => "=");
   Available : Dispatches.Map;


   procedure Register_Command (Name    : in String;
                               Handler : in Dispatchable_Type) is

   begin
      Dispatches.Insert (Available, To_Unbounded_String (Name), Handler);
   end Register_Command;


   procedure Dispatch_Command (Client : in out Client_Type;
                               Command_Access : in Command_Array_Access) is
      Command : constant Command_Array := Command_Access.all;
      Command_Name : constant Unbounded_String := Command (1).Value;
   begin

      if Dispatches.Contains (Available, Command_Name) then
         declare
            Handler : constant Dispatchable_Type := Dispatches.Element (Available, Command_Name);
         begin
            Handler (Client, Command_Access);
         end;
      else
         Mozzoni.Log.Log_Message (Alog.Error, "Could not find handler for: " & To_String(Command_Name));
      end if;

   end Dispatch_Command;

end Mozzoni.Dispatch;
