with System;
with Interfaces.C;

with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

private with Ada.Characters.Latin_1;

package Mozzoni.Client is

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

   -- Determine whether the client data structure is valid
   --
   -- @param Client
   function Is_Valid (Client : in Client_Type) return Boolean;

   -- Read and parse the bytes available on the given client's socket
   --
   -- @param Client a valid Client_Type
   procedure Read_Available (Client : in out Client_Type)
     with Pre => Is_Valid (Client);

   -- Write the given buffer out to the client
   --
   -- @param Buffer a non-zero length string
   procedure Write (Client : in out Client_Type;
                    Buffer : in String);

   -- Write the given character out to the client
   --
   -- @param Char any valid character
   procedure Write (Client : in out Client_Type;
                    Char   : in Character);

   -- Write the given number out to the client as a literal string.
   --
   -- NOTE: this procedure is not going to result in writing an integer to the
   -- socket, but rather a string representation of the integer which is what
   -- the underlying protocol expects
   --
   -- @param Number a number
   procedure Write (Client : in out Client_Type;
                    Number : in Natural);

   -- Write the CRLF line ending to the socket
   procedure Write_Line_Ending (Client : in out Client_Type);

   -- Determine whether a Client is registered
   --
   -- @param Descriptor A valid Socket_Type
   -- @return True when the Descriptor has already be registered.
   function Has_Client (Descriptor : in Socket_Type) return Boolean;

   -- Register a client structure using the given Socket as a key
   --
   -- @param Socket a valid Socket_Type which can be considered a unique identifier
   procedure Register_Client (Socket : in Socket_Type)
     with Post => Has_Client (Socket);

   -- Remove a Client by its specified socket.
   --
   -- @param Socket A valid, and already registered Socket_Type
   procedure Deregister_Client (Socket : in Socket_Type)
     with Pre => Has_Client (Socket),
     Post => not Has_Client (Socket);

   -- Dump_Status will output some potentially useful information to the log
   -- about the current state of the registered Clients
   procedure Dump_Status;

   -- Look up the client given an integer file descriptor
   --
   -- @param Descriptor a file descriptor, typically from C
   -- @return Client_Type the registered client corresponding to the descriptor;
   function Client_For (Descriptor : in Integer) return Client_Type
     with Pre => Descriptor > 0;

   -- Look up the client given a Socket_Type file descriptor
   --
   -- @param Descriptor a socket
   -- @return Client_Type the registered client corresponding to the socket
   function Client_For (Descriptor : in Socket_Type) return Client_Type;


private

   use Ada.Characters.Latin_1;

   function Hash_Descriptor (D : in Integer) return Hash_Type;

   package Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Integer,
                                                   Element_Type    => Client_Type,
                                                   Hash            => Hash_Descriptor,
                                                   Equivalent_Keys => "=");

   Read_Buffer_Size : constant := 128;
   Directory        : Maps.Map;
   Terminator       : constant String :=  CR & LF;

   function Read_Socket (S      : in Socket_Type;
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

   function Close_Socket (S : in Socket_Type) return Integer
     with Import,
       Link_Name => "close",
       Convention => C;

   -- This procedure is only intended to be invoked in tests. It will destroy
   -- *ALL* state for currently registered clients;
   procedure Flush_All_Clients;

end Mozzoni.Client;
