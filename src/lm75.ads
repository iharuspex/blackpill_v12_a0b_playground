with Interfaces; use Interfaces;

with A0B.Types.Arrays;
with A0B.Types.SVD; use A0B.Types.SVD;
with A0B.I2C.Device_Drivers_8;

with Ada.Unchecked_Conversion;

package LM75 is

   type LM75_Sensor (Port : not null access A0B.I2C.I2C_Bus_Master'Class) is
     tagged limited private;

   type I2C_Status is (Ok, Err_Error, Err_Timeout, Busy);

   --  type UInt8_Array is array (Natural range <>) of UInt8;

   subtype I2C_Data is A0B.Types.Arrays.Unsigned_8_Array;

   subtype Temperature is Float range -55.0 .. 125.0;

   type Device_Operation_Mode is (OpMode_Normal, OpMode_Shutdown);

   type OS_Operation_Mode is (OS_Comparator, OS_Interrupt);

   type OS_Polarity_Mode is (OS_Active_Low, OS_Active_High);

   type OS_Fault_Queue_Size is
     (OS_Fault_Num_1, OS_Fault_Num_2, OS_Fault_Num_4, OS_Fault_Num_6)
   with Size => 2;
   for OS_Fault_Queue_Size use
     (OS_Fault_Num_1 => 2#00#,
      OS_Fault_Num_2 => 2#01#,
      OS_Fault_Num_4 => 2#10#,
      OS_Fault_Num_6 => 2#11#);

   procedure Init
     (This           : in out LM75_Sensor;
      Device_Address : in A0B.I2C.Device_Address := 16#90#);

   procedure Configure
     (This         : in out LM75_Sensor;
      OpMode       : Device_Operation_Mode;
      OS_Operation : OS_Operation_Mode;
      OS_Polarity  : OS_Polarity_Mode;
      OS_Fault_Num : OS_Fault_Queue_Size);

   procedure Set_Operation_Mode
     (This : in out LM75_Sensor; OpMode : Device_Operation_Mode);

   function Get_Operation_Mode
     (This : in out LM75_Sensor) return Device_Operation_Mode;

   procedure Set_Hysteresis (This : in out LM75_Sensor; Hyst : Temperature);

   procedure Set_Shutdown_Threshold
     (This : in out LM75_Sensor; Tos : Temperature);

   procedure Get_Hysteresis
     (This : in out LM75_Sensor; Hyst : out Temperature);

   procedure Get_Shutdown_Threshold
     (This : in out LM75_Sensor; Tos : out Temperature);

   procedure Read_Temperature
     (This : in out LM75_Sensor; Temp : out Temperature);

private
   type LM75_Sensor (Port : not null access A0B.I2C.I2C_Bus_Master'Class) is
   tagged limited record
      Address : A0B.I2C.Device_Address;
   end record;

   type Register_Address is new UInt8;

   TEMP_REG  : constant Register_Address := 16#00#;
   CONF_REG  : constant Register_Address := 16#01#;
   THYST_REG : constant Register_Address := 16#02#;
   TOS_REG   : constant Register_Address := 16#03#;

   type CONF_REG_Register is record
      SHUTDOWN    : Bit := 0;
      OS_COMP_INT : Bit := 0;
      OS_POL      : Bit := 0;
      OS_F_QUE    : UInt2 := 0;
      Reserved    : UInt3 := 0;
   end record;

   for CONF_REG_Register use
     record
       SHUTDOWN at 0 range 0 .. 0;
       OS_COMP_INT at 0 range 1 .. 1;
       OS_POL at 0 range 2 .. 2;
       OS_F_QUE at 0 range 3 .. 4;
       Reserved at 0 range 5 .. 7;
     end record;

   function To_Int16 is new Ada.Unchecked_Conversion (UInt16, Integer_16);

   function To_UInt16 is new Ada.Unchecked_Conversion (Integer_16, UInt16);

   function To_UInt8 is new
     Ada.Unchecked_Conversion (CONF_REG_Register, UInt8);

   function To_Reg is new Ada.Unchecked_Conversion (UInt8, CONF_REG_Register);

   Temp_Resolution     : constant := 0.125;
   Tos_THys_Resolution : constant := 0.5;
end LM75;
