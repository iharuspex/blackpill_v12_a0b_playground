with Blackpill_V12; use Blackpill_V12;
with A0B.Time; use A0B.Time;

procedure Blackpill_Playground is
   Blink_Period_Ms : constant Integer := 1000;

begin
   Blackpill_V12.Initialize;

   loop
      LED.Set (To => False);
      Wait_for (Milliseconds (Blink_Period_Ms));

      LED.Set (To => True);
      Wait_for (Milliseconds (Blink_Period_Ms));
   end loop;

end Blackpill_Playground;
