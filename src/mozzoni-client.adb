with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1;

with Mozzoni.Parser; use Mozzoni.Parser;
with Mozzoni.Dispatch; use Mozzoni.Dispatch;

package body Mozzoni.Client is

   procedure Read_Available (Client : in out Client_Type; Socket : in Socket_Type) is
      use Ada.Characters.Latin_1;

      Bytes_Read   : Integer := 0;
      Buffer       : aliased String (1 .. Read_Buffer_Size);
      Parse_Buffer : Unbounded_String := Client.Buffer;
      Command_Buffer : Unbounded_String := Client.Command_Buffer;

      Parse_Exiting : Boolean := False;
   begin
      Put_Line ("Read_Available");
      loop
         Bytes_Read := Integer (Read_Socket (Socket, Buffer'Address, Buffer'Length));
         if Mozzoni.Error_Number /= 0 then
            Put_Line ("Errno set while reading socket:" & Integer'Image (Mozzoni.Error_Number));
         end if;

         exit when Bytes_Read = 0;

         -- Nothing went wrong, which means we've got a buffer to work
         Append (Parse_Buffer, Buffer (1 .. Bytes_Read));
      end loop;

      -- Now that we have read what we can, let's push the state machine forward
      for Ch of To_String (Parse_Buffer) loop
         if Client.Current_RESP_Type = Mozzoni.None then
            case Ch is
            when '*' => Client.Current_RESP_Type := Mozzoni.List;
            when others =>
               Client.Current_RESP_Type := Mozzoni.Human_Readable;
               Append (Command_Buffer, Ch);
            end case;
         else
            if Ch = CR then
               Parse_Exiting := True;
            elsif Parse_Exiting and Ch = LF then
               case Client.Current_RESP_Type is
                  when Mozzoni.List =>
                     Put_Line ("Handle List " & To_String (Command_Buffer));
                     -- Read the rest of the commmand
                     -- Dispatch
                  when Mozzoni.Human_Readable =>
                     Put_Line ("handle human readable " & To_String (Command_Buffer));
                     -- Dispatch the parsed command
                     Dispatch_Command (Client, Parse_Human_Readable_Command (Command_Buffer));
                  when others => null;
               end case;
               Client.Current_RESP_Type := Mozzoni.None;
               Delete (Command_Buffer, 1, Length (Command_Buffer));
            else
               Append (Command_Buffer, Ch);
            end if;
         end if;

      end loop;
      -- Once we've processed the Parse_Buffer, we need to delete its contents
      -- before Read_Available is called again
      Delete (Parse_Buffer, 1, Length (Parse_Buffer));

   end Read_Available;


   procedure Write (Client : in out Client_Type;
                    Buffer : in String) is
      Written : Integer := 0;
   begin
      Written := Integer (Write_Socket (Client.Socket, Buffer'Address, Buffer'Length));
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
      Maps.Insert (Directory, Client.Descriptor, Client);
   end Register_Client;


   function Client_For (Descriptor : in Integer) return Client_Type is
   begin
      if Maps.Contains (Directory, Descriptor) then
         return Maps.Element (Directory, Descriptor);
      end if;
   end Client_For;

   function Client_For (Descriptor : in Socket_Type) return Client_Type is
   begin
      return Client_For (To_C (Descriptor));
   end Client_For;

end Mozzoni.Client;
