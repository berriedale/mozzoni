

with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

package Mozzoni.Client is

   Read_Buffer_Size : constant := 32;

   type Client_Type is tagged record
      Descriptor : Integer;
      ID         : Unbounded_String;
      Socket     : Socket_Type;
      Buffer     : Unbounded_String;
      -- IP Address
      -- Client_Port_Number
   end record;
   procedure Read_Available (Client : Client_Type; Socket : in Socket_Type);


   procedure Register_Client (Socket : in Socket_Type);

   function Client_For (Descriptor : in Integer) return Client_Type;
   function Client_For (Descriptor : in Socket_Type) return Client_Type;

   function Hash_Descriptor (D : in Integer) return Hash_Type;

   package Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Integer,
                                                   Element_Type    => Client_Type,
                                                   Hash            => Hash_Descriptor,
                                                   Equivalent_Keys => "=");

   Directory : Maps.Map;

end Mozzoni.Client;
