

with Ada.Calendar;
with Ada.Strings.Unbounded.Hash;
with Ada.Containers.Hashed_Maps; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

---
-- Mozzoni.Store.KeyValue implements a simplistic key-value store interface
-- with automatic expiration of items based on time or memory pressure
---
package Mozzoni.Store.KeyValue is

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
      Buffer : Unbounded_String;
      Expiration : Ada.Calendar.Time := No_Expiry;
   end record;

   ---
   -- No_Value is a sentinel value used to indicate that the given key
   -- does not exist in the store
   No_Value : constant Value_Type := (Buffer => Null_Unbounded_String,
                                      Expiration => No_Expiry);

   ---
   -- Quickly verify that the given Key is valid for storage
   --
   -- @param Key a valid Key_Type
   -- @return True if the Key is valid, False otherwise.
   function Is_Valid_Key (Key : in Key_Type) return Boolean;

   -- Checks whether the given key exists in the key/value store
   function Exists (Key : in Key_Type) return Boolean
     with Pre => Is_Valid_Key (Key);

   ---
   -- Is_Expired determines whether the given key has expired from the store
   --
   -- @param Key a valid Key
   -- @return True if the key does not exist or has an Expiration which has past
   ---
   function Is_Expired (Key : in Key_Type) return Boolean
     with Pre => Is_Valid_Key (Key);

   ---
   -- Set inserts a new value into the store
   -- @param Key the key for the new value
   -- @param Value a properly formed Value_Type
   -- @return True if the set operation could be completed successfully
   ----
   function Set (Key : in Key_Type;
                 Value : in Value_Type) return Boolean
     with Pre => Is_Valid_Key (Key);

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
     with Pre => Is_Valid_Key (Key);

   ---
   -- Flush is a *VERY DANGEROUS* subprogram to invoke and will flush all keys
   -- and values *IMMEDIATELY* from the store
   ---
   procedure Flush;

private

   package Hashed_Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Key_Type,
                                                          Element_Type    => Value_Type,
                                                          Hash            => Ada.Strings.Unbounded.Hash,
                                                          Equivalent_Keys => "=");
   Store : Hashed_Maps.Map;


end Mozzoni.Store.KeyValue;
