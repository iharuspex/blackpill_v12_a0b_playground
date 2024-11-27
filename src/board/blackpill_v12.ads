with A0B.STM32F401.I2C.Generic_I2C1;
with A0B.STM32F401.DMA.DMA1.Stream6;
with A0B.STM32F401.DMA.DMA1.Stream0;
with A0B.STM32F401.GPIO;      use A0B.STM32F401.GPIO;
with A0B.STM32F401.GPIO.PIOC; use A0B.STM32F401.GPIO.PIOC;
with A0B.STM32F401.GPIO.PIOB;
with A0B.Time;

package Blackpill_V12
  with Preelaborate
is
   subtype User_LED is GPIO_Line;

   LED : User_LED renames PC13;

   --  procedure Set    (Pin : User_LED) renames
   --     A0B.STM32F401.GPIO.Set (Self => Pin, To => False);
   --  procedure Reset  (Pin : User_LED) renames
   --     A0B.STM32F401.GPIO.Set (Self => Pin, To => True);
   --  procedure Toggle (LED_Pin : in out User_LED);

   --  procedure Init_RCC;

   --  procedure Init_LED renames Configure_Output;

   package I2C1 is new
     A0B.STM32F401.I2C.Generic_I2C1
       (Transmit_Stream => A0B.STM32F401.DMA.DMA1.Stream6.DMA1_Stream6'Access,
        Receive_Stream  => A0B.STM32F401.DMA.DMA1.Stream0.DMA1_Stream0'Access,
        SCL_Pin         => A0B.STM32F401.GPIO.PIOB.PB6'Access,
        SDA_Pin         => A0B.STM32F401.GPIO.PIOB.PB7'Access);

   I2C : A0B.I2C.I2C_Bus_Master'Class
     renames A0B.I2C.I2C_Bus_Master'Class (I2C1.I2C1);

   procedure Initialize;

   procedure Wait_for (Duration : A0B.Time.Time_Span);

end Blackpill_V12;
