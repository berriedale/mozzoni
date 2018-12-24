with Ada.Characters.Latin_1;

with Mozzoni.Dispatch; use Mozzoni.Dispatch;

package body Mozzoni.Client is
   use Ada.Characters.Latin_1;

   Terminator : constant String :=  CR & LF;


   procedure Parse_Available (Client : in out Client_Type) is

      Buffer : Unbounded_String := Client.Buffer;
      Ch : Character := NUL;
      Seek_Index : Natural := 0;

      Read_Number : Natural := 0;

      procedure Increment_Offset is
      begin
         Client.Offset := Client.Offset + 1;
      end Increment_Offset;

      function Next_Terminator return Natural is
      begin
         return Index (Client.Buffer, Terminator, Client.Offset);
      end Next_Terminator;

      function Slice_To_Terminator return String is
      begin
         return Slice (Client.Buffer,
                       Client.Offset,
                       Next_Terminator - 1);
      end Slice_To_Terminator;

      procedure Split_Human_Readable (C : in Client_Type) is
      begin
         null;
      end Split_Human_Readable;

   begin

      if Client.Offset = 1 then
         case Element (Buffer, Client.Offset) is
            when '*' =>
               Client.Current_RESP_Type := Mozzoni.List;
               Increment_Offset;

               -- Find the index of the next terminator in order to determine the list
               Seek_Index := Next_Terminator;

               if Seek_Index = 0 then
                  Mozzoni.Log.Log_Message (Alog.Warning, "Terminator not found in Parse_Available!");
                  return;
               end if;

               Read_Number := Natural'Value (Slice_To_Terminator);

               Client.Command := new Command_Array (1 .. (Read_Number + 1));
            when others =>
               Client.Current_RESP_Type := Mozzoni.Human_Readable;
               -- We're going to assume for now that no human readable command is
               -- going to have more than sixteen components
               Client.Command := new Command_Array (1 .. 16);
         end case;
      end if;

      -- If we do not have an allocated Command_Array yet, then there's no point
      -- in attempting to further parse the buffer. We need more bytes in the
      -- buffer to continue
      if Client.Command = null then
         return;
      end if;

      loop
         exit when Client.Offset >= Length (Buffer);

         Seek_Index := 0;
         Read_Number := 0;

         Ch := Element (Buffer, Client.Offset);
         Increment_Offset;

         case Ch is
            when '$' =>
               -- This item is a string and the bytes between "here" and the
               -- terminator will tell us how long the string is
               Read_Number := Natural'Value (Slice_To_Terminator);
               Seek_Index := Next_Terminator + 2;

               Client.Parsed_Command := Client.Parsed_Command + 1;
               -- Slice out the command without taking the trailing terminator
               Client.Command (Client.Parsed_Command) := (Mozzoni.Bulk,
                                                          Unbounded_Slice (Buffer,
                                                            Seek_Index,
                                                            Seek_Index + Read_Number - 1));

               -- Bump the offset to include the read buffer and the next terminator
               Client.Offset := (Seek_Index + Read_Number + 2);
            when CR =>
               if Client.Current_RESP_Type = Mozzoni.Human_Readable then
                  Client.Parsed_Command := Client.Parsed_Command + 1;
                  Client.Command (Client.Parsed_Command) := (Mozzoni.Bulk,
                                                             Unbounded_Slice (Buffer, 1, Client.Offset - 2));
               end if;
            when others => null;
         end case;
      end loop;

      if (Client.Parsed_Command = (Client.Command'Length - 1)) or
         (Client.Current_RESP_Type = Mozzoni.Human_Readable) then
         -- We have all our commands parts, which means we can dispatch!
         Dispatch_Command (Client, Client.Command);
         Delete (Client.Buffer, 1, Length (Client.Buffer));
      else
         Mozzoni.Log.Log_Message (Alog.Warning, "Not enough data yet to dispatch");
      end if;

   end Parse_Available;


   procedure Read_Available (Client : in out Client_Type; Socket : in Socket_Type) is
      Bytes_Read   : Integer := 0;
      Buffer       : aliased String (1 .. Read_Buffer_Size);
   begin

      loop
         Bytes_Read := Integer (Read_Socket (Socket, Buffer'Address, Read_Buffer_Size));
         if Mozzoni.Error_Number /= 0 and Mozzoni.Error_Number /= 22 then
            Mozzoni.Log.Log_Message (Alog.Error, "Errno set while reading socket:" & Integer'Image (Mozzoni.Error_Number));
         end if;

         exit when Bytes_Read = 0;

         -- Nothing went wrong, which means we've got a buffer to work
         Append (Client.Buffer, Buffer (1 .. Bytes_Read));

         -- No need to loop around if we read a buffer from the socket which is
         -- less than our available space, indicating that there is nothing left to read.
         exit when Bytes_Read < Buffer'Length;
      end loop;

      if Length (Client.Buffer) > 0 then
         Parse_Available (Client);
      end if;

   end Read_Available;


   procedure Write (Client : in out Client_Type;
                    Buffer : in String) is
   begin
      String'Write (Client.Stream, Buffer);
   end Write;

   procedure Write (Client    : in out Client_Type;
                    Char : in Character) is
   begin
      Character'Write (Client.Stream, Char);
   end Write;

   procedure Write (Client : in out Client_Type;
                    Number : in Natural) is
      -- Convert to a string for writing to the socket
      As_String : String := Natural'Image (Number);
   begin
      -- BUG: This doesn't seem to write anything to the stream, so we need
      -- to write the value "the hard way"
      -- Natural'Write (Client.Stream, Number);

      -- The first character will be a ' ' for Naturals to signify that it is
      -- greater than zero. Negative Integers for example will have a first character
      -- of '-' to signify negativity.
      Client.Write (As_String (2 .. As_String'Length));
   end Write;


   function Is_Valid (Client : in Client_Type) return Boolean is
   begin
      return True;
      -- TODO
   end Is_Valid;


   function Hash_Descriptor (D : in Integer) return Hash_Type is
   begin
      return Hash_Type (D);
   end Hash_Descriptor;


   procedure Register_Client (Socket : in Socket_Type) is
      Client : Client_Type;
   begin
      Client.Socket := Socket;
      Client.Descriptor := To_C (Socket);
      Client.Stream := Stream (Socket);
      Maps.Insert (Directory, Client.Descriptor, Client);
   end Register_Client;


   function Client_For (Descriptor : in Integer) return Client_Type is
   begin
      if Maps.Contains (Directory, Descriptor) then
         return Maps.Element (Directory, Descriptor);
      else
         raise Constraint_Error with "Failed to find a client for " & Integer'Image (Descriptor);
      end if;
   end Client_For;

   function Client_For (Descriptor : in Socket_Type) return Client_Type is
   begin
      return Client_For (To_C (Descriptor));
   end Client_For;

end Mozzoni.Client;
