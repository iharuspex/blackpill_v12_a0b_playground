pragma Restrictions (No_Elaboration_Code);

with A0B.Time;
with A0B.Types.Arrays;
with A0B.Callbacks;

package A0B.I2C.LM75
   with Preelaborate
is

   type LM75_Command is mod 2**16;

   type Transaction_Status is record
      Written_Octets : A0B.Types.Unsigned_32;
      Read_Octets    : A0B.Types.Unsigned_32;
      State          : A0B.Operation_Status;
   end record;

   type LM75_Driver
      (Controller : not null access I2C_Bus_Master'Class;
       Address : Device_Address) is
      limited new Abstract_I2C_Device_Driver with private
        with Preelaborable_Initialization;

   procedure Send_Command
      (Self          : in out LM75_Driver'Class;
       Command       : LM75_Command;
       Input         : A0B.Types.Arrays.Unsigned_8_Array;
       Status        : aliased out Transaction_Status;
       On_Completed  : A0B.Callbacks.Callback;
       Success       : in out Boolean);

   procedure Write
      (Self          : in out LM75_Driver'Class;
       Command       : LM75_Command;
       Input         : A0B.Types.Arrays.Unsigned_8_Array;
       Status        : aliased out Transaction_Status;
       On_Completed  : A0B.Callbacks.Callback;
       Success       : in out Boolean);

   procedure Read
      (Self          : in out LM75_Driver'Class;
       Command       : LM75_Command;
       Input         : A0B.Types.Arrays.Unsigned_S8_Array;
       Status        : aliased out Transaction_Status;
       On_Completed  : A0B.Callbacks.Callback;
       Success       : in out Boolean);

   procedure Send_Command_And_Fetch_Result
     (Self           : in out LM75_Driver'Class;
      Command        : LM75_Command;
      Input          : A0B.Types.Arrays.Unsigned_8_Array;
      Delay_Interval : A0B.Time.Time_Span;
      Response       : out A0B.Types.Arrays.Unsigned_8_Array;
      Status         : aliased out Transaction_Status;
      On_Completed   : A0B.Callbacks.Callback;
      Success        : in out Boolean);
private

   type State is
      (Initial,
       Command,
       Command_Read,
       Write,
       Write_Read,
       Read);

   type LM75_Driver
      (Controller : not null access I2C_Bus_Master'Class;
       Address    : Device_Address) is
   limited new Abstract_I2C_Device_Driver with record
      State          : LM75_Driver.State := Initial;
      Delay_Interval : A0B.Time.Time_Span;
      On_Completed   : A0B.Callbacks.Callback;
      Transaction    : access Transaction_Status;

      Command_Buffer : A0B.Types.Arrays.Unsigned_8_Array (0 .. 1);
      Write_Buffer   : A0B.I2C.Buffer_Descriptor_Array (0 .. 1);
      Read_Buffer    : A0B.I2C.Buffer_Descriptor_Array (0 .. 0);
   end record;

   overriding function Target_Address
      (Self : LM75_Driver) return Device_Address is (Self.Address);

   overriding procedure On_Transfer_Complete (Self : in out LM75_Driver);

   overriding procedure On_Transaction_Complete (Self : in out LM75_Driver);

end A0B.I2C.LM75;