
with GNAT.Sockets,
     Interfaces.C,
     System;

package Epoll is

    subtype Epoll_Fd_Type is Integer;

    type Epoll_Events_Type is (Epoll_In,
                               Epoll_Pri,
                               Epoll_Out,
                               Epoll_In_And_Out,
                               Epoll_Et,
                               Epoll_In_And_Et
                              );
    for Epoll_Events_Type use (Epoll_In => 1,
                                Epoll_Pri => 2,
                               Epoll_Out => 4,
                               Epoll_In_And_Out => 5,
                                Epoll_Et  => 2147483648,
                                Epoll_In_And_Et => 2147483649);
    for Epoll_Events_Type'Size use Interfaces.C.int'Size;

    type Epoll_Ctl_Type is (Epoll_Ctl_Add,
                            Epoll_Ctl_Del,
                            Epoll_Ctl_Mod);
    for Epoll_Ctl_Type use (Epoll_Ctl_Add => 1,
                             Epoll_Ctl_Del => 2,
                             Epoll_Ctl_Mod => 3);

    type Data_Type (Discriminant : Interfaces.C.unsigned := 0) is record
        case Discriminant is
            when 0 =>
                Ptr : System.Address;
            when 1 =>
                FD  : aliased GNAT.Sockets.Socket_Type; -- Interfaces.C.int
            when 2 =>
                U32 : aliased Interfaces.Unsigned_32;
            when others =>
                U64 : aliased Interfaces.Unsigned_64;
        end case;
   end record
     with Unchecked_Union,
       Convention => C_Pass_By_Copy;

    type Event_Type is record
        Events : aliased Epoll_Events_Type;
        Data   : Data_Type;
   end record
     with Convention => C_Pass_By_Copy;

   type Event_Array_Type is array (Integer range <>) of aliased Event_Type
     with Convention => C;


   function Create (Size : Integer) return Epoll_Fd_Type
     with Import,
     Link_Name => "epoll_create",
     Convention => C;

    function Control (Epfd : Epoll_Fd_Type;
                      Op : Epoll_Ctl_Type;
                      Fd : Epoll_Fd_Type;
                      Events : access Event_Type) return Integer
     with Import,
     Link_Name => "epoll_ctl",
     Convention => C;

    function Wait (Epfd : Epoll_Fd_Type;
                   Events : access Event_Type;
                   Max_Events : Integer;
                   Timeout    : Integer) return Integer
     with Import,
     Link_Name => "epoll_wait",
       Convention => C;
end Epoll;
