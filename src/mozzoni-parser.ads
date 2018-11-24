
with Mozzoni;
with Ada.Streams;
with Ada.Unchecked_Conversion;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

--
-- Mozzoni.Parser encapsulates the entirety of the parsing engine and types
-- for handling RESP commands.
--
-- See https://redis.io/topics/protocol for a full outline of the protocl which
-- must be parsed
package Mozzoni.Parser is


   function Convert_Byte is new Ada.Unchecked_Conversion (Ada.Streams.Stream_Element, Character);

   --
   -- Read_To_CRLF will read the remainder of the line in the Channel until
   -- it reaches the expected \r\n which indicates the end of an entry in RESP
   --
   -- @return An unprocessed/parsed and unbounded string
   function Read_To_CRLF (Channel : in Stream_Access) return Unbounded_String
     with Pre => Channel /= null;


   -- Handle_Bulk will appropriate allocate and read the bulk string in from
   -- the given Channel
   function Read_Bulk (Channel : in Stream_Access;
                       Length  : in Natural) return Unbounded_String
     with Pre => Channel /= null and Length > 0;


   -- Read_Item will read from the given Channel and return a single Command_Item
   -- which represents a single type of "thing" in RESP, such as a Simple String
   -- an Integer, an Error, etc.
   function Read_Item (Channel : in Stream_Access) return Command_Item
     with Pre => Channel /= null;

   function Read_Command_List (Channel : Stream_Access;
                               Item_Count : in Natural) return Command_Array_Access
     with Pre => Channel /= null and Item_Count > 0;


end Mozzoni.Parser;
