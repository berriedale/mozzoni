

with Ada.Calendar;
with Ada.Strings.Unbounded.Hash;
with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


--
-- Mozzoni.Store is responsible for storing and managing data of various types
-- for Mozzoni.
--
package Mozzoni.Store is


   -- Constant to denote that there is no expiration for a Value_Type
   No_Expiry : constant Ada.Calendar.Time := Ada.Calendar.Time_Of (1970, 1, 1);

   -- Type for describing the keys for the key/value store
   subtype Key_Type is Unbounded_String;

   -- Value_Type contains the necessary metadata for the storing and expiring
   -- values in the key/value store
   --
   -- @field Buffer The raw unparsed value to store/retrieve.
   -- @field Expiration Time (UTC) when the record should be expunged from the store
   type Value_Type is record
      Buffer     : Unbounded_String;
      Expiration : Ada.Calendar.Time := No_Expiry;
   end record;

   ---
   -- No_Value is a sentinel value used to indicate that the given key
   -- does not exist in the store
   No_Value : constant Value_Type := (Buffer     => Null_Unbounded_String,
                                      Expiration => No_Expiry);

   package Hashed_Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Key_Type,
                                                          Element_Type    => Value_Type,
                                                          Hash            => Ada.Strings.Unbounded.Hash,
                                                          Equivalent_Keys => "=");


   ---
   -- Quickly verify that the given Key is valid for storage
   --
   -- @param Key a valid Key_Type
   -- @return True if the Key is valid, False otherwise.
   function Is_Valid_Key (Key : in Key_Type) return Boolean;


   -- KeyValue is a protected object which manages proper task-safe access to
   -- the internal key/value storage in Mozzoni
   protected KeyValue is
   -- Checks whether the given key exists in the key/value store
      function Exists (Key : in Key_Type) return Boolean
        with Pre => Mozzoni.Store.Is_Valid_Key (Key);

      -- Remove a Key from the store
      --
      -- To avoid too many traversals of the protected object boundary, this
      -- function will return a Boolean to indicate to the caller that the key
      -- existed before it was purged.
      --
      -- @param Key a valid key
      -- @return Boolean True if the key existed, otherwise false.
      function Remove (Key : in Key_Type) return Boolean
        with Pre => Mozzoni.Store.Is_Valid_Key (Key);

      ---
      -- Is_Expired determines whether the given key has expired from the store
      --
      -- @param Key a valid Key
      -- @return True if the key does not exist or has an Expiration which has past
      ---
      function Is_Expired (Key : in Key_Type) return Boolean
        with Pre => Mozzoni.Store.Is_Valid_Key (Key);

      ---
      -- Set inserts a new value into the store
      -- @param Key the key for the new value
      -- @param Value a properly formed Value_Type
      ----
      procedure Set (Key   : in Key_Type;
                     Value : in Value_Type)
        with Pre => Mozzoni.Store.Is_Valid_Key (Key);

      ---
      -- Get will return the Value_Type, assuming it exists and has not expired, for
      -- the given Key.
      --
      -- If there is not a corresponding value in the store, then a No_Value will be
      -- returned
      --
      -- @param Key the key for the value to retriev
      -- @return The stored Value_Type if the key exists and has not expired, *or*
      --         the No_Value constant
      function Get (Key : in Key_Type) return Value_Type
        with Pre => Mozzoni.Store.Is_Valid_Key (Key);

      ---
      -- Flush is a *VERY DANGEROUS* subprogram to invoke and will flush all keys
      -- and values *IMMEDIATELY* from the store
      ---
      procedure Flush;

   private
      Store : Hashed_Maps.Map;
   end KeyValue;

end Mozzoni.Store;
