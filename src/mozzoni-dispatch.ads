

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Mozzoni.Client; use Mozzoni.Client;

package Mozzoni.Dispatch is

   Command_Name_Max : constant := 16;
   subtype Command_Name_Type is String (1 .. Command_Name_Max);

   type Dispatchable_Type is not null access procedure (C  : in out Client_Type;
                                                        CA : in Command_Array_Access);

   function Is_Registered (Name : in String) return Boolean
     with Pre => Name'Length > 0;

   procedure Dispatch_Command (Client         : in out Client_Type;
                               Command_Access : in Command_Array_Access)
     with Pre =>
       (Client.Descriptor >= 0
        and Command_Access /= null);

   procedure Register_Command (Name : in String;
                               Handler : in Dispatchable_Type)
     with Pre => Name'Length > 0,
       Post => Is_Registered (Name);


end Mozzoni.Dispatch;
