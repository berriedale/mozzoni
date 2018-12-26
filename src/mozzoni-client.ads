with System;
with Interfaces.C;

with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

package Mozzoni.Client is

   Read_Buffer_Size : constant := 128;

   type Client_Type is tagged record
      Descriptor        : Integer;
      Socket            : Socket_Type;
      Stream            : Stream_Access;
      Buffer            : Unbounded_String;
      Current_RESP_Type : RESP_Type := Mozzoni.None;
      Command           : Command_Array_Access := null;
      Parsed_Command    : Natural := 0;
      -- Offset in the buffer the parser is currently finished
      Offset            : Natural := 1;
      -- IP Address
      -- Client_Port_Number
   end record;
   procedure Read_Available (Client : in out Client_Type; Socket : in Socket_Type);
   procedure Write (Client : in out Client_Type;
                    Buffer : in String);
   procedure Write (Client : in out Client_Type;
                    Char : in Character);
   procedure Write (Client : in out Client_Type;
                    Number : in Natural);
   function Is_Valid (Client : in Client_Type) return Boolean;


   procedure Register_Client (Socket : in Socket_Type);
   procedure Deregister_Client (Socket : in Socket_Type);
   procedure Dump_Status;

   function Client_For (Descriptor : in Integer) return Client_Type;
   function Client_For (Descriptor : in Socket_Type) return Client_Type;

   function Hash_Descriptor (D : in Integer) return Hash_Type;

   package Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Integer,
                                                   Element_Type    => Client_Type,
                                                   Hash            => Hash_Descriptor,
                                                   Equivalent_Keys => "=");

   Directory : Maps.Map;




   function Read_Socket (S      : in GNAT.Sockets.Socket_Type;
                         Buffer : in System.Address;
                         Count  : Interfaces.C.size_t) return Interfaces.C.size_t
     with Import,
     Link_Name => "read",
     Convention => C;

   function Write_Socket (S      : in Socket_Type;
                          Buffer : in System.Address;
                          Count  : Interfaces.C.size_t) return Interfaces.C.size_t
     with Import,
     Link_Name => "write",
     Convention => C;

   function Close_Socket (S : in Socket_Type) return Interfaces.C.int
     with Import,
       Link_Name => "close",
       Convention => C;


end Mozzoni.Client;
