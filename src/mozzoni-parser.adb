

with Ada.Characters.Latin_1;
with Ada.Streams;

with Mozzoni; use Mozzoni;

package body Mozzoni.Parser is


   function To_Natural (Buffer : in Unbounded_String) return Natural is
   begin
      return Natural'Value (To_String (Buffer));
   end To_Natural;


   function Read_To_CRLF (Channel : in Stream_Access) return Unbounded_String is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Bytes   : Stream_Element_Array (1 .. 1);
      Offset  : Stream_Element_Count;
      Exiting : Boolean := False;
      Char    : Character := NUL;

      Buffer : Unbounded_String;
   begin
      loop
         Read (Channel.all, Bytes, Offset);
         exit when Offset = 0;

         Char := Convert_Byte (Bytes (1));

         case Char is
            when CR =>
               Exiting := True;
            when LF =>
               exit when Exiting;
            when others =>
               Append (Buffer, Char);
         end case;
      end loop;
      return Buffer;
   end Read_To_CRLF;


   function Read_Bulk (Channel : in Stream_Access;
                       Length  : in Natural) return Unbounded_String is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Expected_Size : constant Stream_Element_Offset := Stream_Element_Offset (Length);
      -- TODO:: Expected_Size will be 64 bits, on 32 bit platforms Integer may
      -- not be 32 bits as well, and we might truncate here.
      Bulk_String   : String (1 .. (Length + 2));
   begin
      String'Read (Channel, Bulk_String);
      -- Trim the trailing \r\n before returning.
      return To_Unbounded_String (Bulk_String (1  .. Length));
   end Read_Bulk;

   function Read_Item (Channel : in Stream_Access) return Command_Item is
      use Ada.Streams;
      use Ada.Characters.Latin_1;

      Bytes   : Stream_Element_Array (1 .. 1);
      Offset  : Stream_Element_Count;
      Exiting : Boolean := False;
      Char    : Character := NUL;

      Item             : Command_Item;
      Bulk_Read_Length : Natural := 0;
   begin
      loop
         Bulk_Read_Length := 0;

         Read (Channel.all, Bytes, Offset);
         exit when Offset = 0;
         Char := Convert_Byte (Bytes (1));

         case Char is
            when '+' =>
               -- Simple String
               Item.Value := Read_To_CRLF (Channel);
               Item.Item_Type := Simple_String;
            when ':' =>
               -- Integer
               Item.Value := Read_To_CRLF (Channel);
               Item.Item_Type := Int;
            when '$' =>
               -- First read the length
               Item.Value := Read_To_CRLF (Channel);
               Item.Item_Type := Bulk;

               Bulk_Read_Length := To_Natural (Item.Value);
               Item.Value := Read_Bulk (Channel, Bulk_Read_Length);
               -- Since we've read an item properly, bail out early with it
               return Item;

            when others => null;
         end case;
      end loop;
      return Item;
   end Read_Item;

   function Read_Command_List (Channel      : in Stream_Access;
                               Item_Count   : in Natural) return Command_Array_Access is
      Pieces : Command_Array_Access := new Command_Array (1 .. Item_Count);
   begin
      for Index in 1 .. Item_Count loop
         Pieces (Index) := Read_Item (Channel);
      end loop;
      return Pieces;
   end Read_Command_List;
end Mozzoni.Parser;
