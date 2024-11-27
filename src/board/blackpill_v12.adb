with A0B.ARMv7M.SysTick_Clock;

package body Blackpill_V12 is

   procedure Initialize is
   begin
      A0B.ARMv7M.SysTick_Clock.Initialize
        (Use_Processor_Clock => True, Clock_Frequency => 84_000_000);

      LED.Configure_Output;

      I2C1.I2C1.Configure;
   end Initialize;

   ---------------
   -- Wait_for --
   ---------------

   procedure Wait_for (Duration : A0B.Time.Time_Span) is
      use A0B.Time;

      Target : constant Monotonic_Time :=
        A0B.ARMv7M.SysTick_Clock.Clock + Duration;

      Current : Monotonic_Time := To_Monotonic_Time (0);
   begin
      while Current < Target loop
         Current := A0B.ARMv7M.SysTick_Clock.Clock;
      end loop;
   end Wait_for;

end Blackpill_V12;
