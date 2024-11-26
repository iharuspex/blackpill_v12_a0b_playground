with A0B.ARMv7M.SysTick_Clock;
with A0B.STM32F401.GPIO.PIOC;
with A0B.Time; use A0B.Time;

--  with LM75;

procedure Simple_Stm32_Project is
   LED_Pin : A0B.STM32F401.GPIO.GPIO_Line renames A0B.STM32F401.GPIO.PIOC.PC13;

   Blink_Period_Ms : constant Integer := 300;

   procedure Wait_for (Duration : Time_Span);

   ---------------
   -- Wait_for --
   ---------------

   procedure Wait_for (Duration : Time_Span) is
      Target : constant Monotonic_Time :=
        A0B.ARMv7M.SysTick_Clock.Clock + Duration;

      Current : Monotonic_Time := To_Monotonic_Time (0);
   begin
      while Current < Target loop
         Current := A0B.ARMv7M.SysTick_Clock.Clock;
      end loop;
   end Wait_for;

begin
   A0B.ARMv7M.SysTick_Clock.Initialize
     (Use_Processor_Clock => True, Clock_Frequency => 84_000_000);

   LED_Pin.Configure_Output;

   loop
      LED_Pin.Set (To => False);
      Wait_for (Milliseconds (Blink_Period_Ms));

      LED_Pin.Set (To => True);
      Wait_for (Milliseconds (Blink_Period_Ms));
   end loop;

end Simple_Stm32_Project;
