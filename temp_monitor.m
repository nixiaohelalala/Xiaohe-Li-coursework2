% temp_monitor - Monitors temperature and controls LEDs based on the temperature reading
%     This function continuously monitors the temperature using an Arduino connected
%     to a temperature sensor. Depending on the temperature, it controls the state
%     of three LEDs to indicate the temperature status.
%
%     Syntax:
%         >> temp_monitor(a, greenLEDPin, yellowLEDPin, redLEDPin)
%
%     Parameters:
%         a - Initialized Arduino object connected to the temperature sensor.
%         greenLEDPin - Arduino digital pin number to which the green LED is connected.
%         yellowLEDPin - Arduino digital pin number to which the yellow LED is connected.
%         redLEDPin - Arduino digital pin number to which the red LED is connected.
%
%     Notes:
%         - The green LED indicates a comfortable temperature range (18-24°C).
%         - The yellow LED blinks intermittently if the temperature is below the comfortable range.
%         - The red LED blinks faster if the temperature is above the comfortable range.
%         - This function assumes that the temperature sensor is correctly calibrated and connected.
%
%     Examples:
%         >> a = Arduino('COM3', 'UNO');
%         >> temp_monitor(a, 2, 3, 4)
%
%     See also: Arduino, readTemperature, writeDigitalPin
%