package Mozzoni.Commands.Connection is

   procedure Handle_Ping (Client  : in out Client_Type;
                          Command : Command_Array_Access)
     with Pre => Client.Is_Valid and Command /= null;

   procedure Handle_Echo (Client : in out Client_Type;
                          Command : Command_Array_Access)
     with Pre => Client.Is_Valid and Command /= null;

   procedure Handle_Quit (Client : in out Client_Type;
                          Command : Command_Array_Access)
     with Pre => Client.Is_Valid and Command /= null;


end Mozzoni.Commands.Connection;
