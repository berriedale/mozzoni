with Ada.Text_IO; use Ada.Text_IO;

package body Mozzoni.Client is

   procedure Read_Available (Client : in Client_Type; Socket : in Socket_Type) is
      Bytes_Read   : Integer := 0;
      Buffer       : aliased String (1 .. Read_Buffer_Size);
      Parse_Buffer : Unbounded_String := Client.Buffer;
   begin
      Put_Line ("Read_Available");
      loop
         Bytes_Read := Integer (Read_Socket (Socket, Buffer'Address, Buffer'Length));
         exit when Bytes_Read = 0;

         if Mozzoni.Error_Number = 0 then
            -- Nothing went wrong, which means we've got a buffer to work
            Append (Parse_Buffer, Buffer (1 .. Bytes_Read));
         else
            Put_Line ("errno:" & Integer'Image (Mozzoni.Error_Number));
         end if;
      end loop;
   end Read_Available;


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
