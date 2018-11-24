

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

package Mozzoni.Dispatch is

   Command_Name_Max : constant := 16;
   subtype Command_Name_Type is String (1 .. Command_Name_Max);

   type Dispatchable_Type is not null access procedure (C : in Stream_Access; CA : in Command_Array_Access);

   procedure Dispatch_Command (Channel : in Stream_Access;
                          Command_Access : in Command_Array_Access)
     with Pre => Channel /= null and Command_Access /= null;

   procedure Register_Command (Name : in String;
                               Handler : in Dispatchable_Type)
     with Pre => Name'Length > 0;


end Mozzoni.Dispatch;
