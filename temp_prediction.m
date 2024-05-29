function temp_prediction(a)
    % Assume 'a' is the initialized Arduino object
    sampleRate = 1; % Sampling rate in seconds
    predictionTime = 5 * 60; % Total seconds in 5 minutes
    tempChangeThreshold = 4; % Temperature change threshold in °C/min
    
    % Initialize variables
    currentTemp = readTemperature(a); % Read initial temperature
    tempChangeRate = 0; % Initialize the rate of temperature change
    lastTemp = currentTemp; % Last temperature reading
    
    % Continuously monitor temperature
    while true
        currentTemp = readTemperature(a); % Read the current temperature
        tempChangeRate = (currentTemp - lastTemp) / sampleRate; % Calculate the rate of change
        lastTemp = currentTemp; % Update the last temperature reading
        
        % Predict the temperature in 5 minutes
        predictedTemp = currentTemp + tempChangeRate * predictionTime;
        
        % Display current and predicted temperatures
        fprintf('Current Temperature: %.2f °C\n', currentTemp);
        fprintf('Predicted Temperature in 5 minutes: %.2f °C\n', predictedTemp);
        
        % Control LEDs based on the rate of temperature change
        if tempChangeRate > tempChangeThreshold
            controlLED(a, 'red', 'on'); % Turn on red LED
            controlLED(a, 'yellow', 'off'); % Turn off yellow LED
        elseif tempChangeRate < -tempChangeThreshold
            controlLED(a, 'yellow', 'on'); % Turn on yellow LED
            controlLED(a, 'red', 'off'); % Turn off red LED
        else
            controlLED(a, 'green', 'on'); % Turn on green LED
            controlLED(a, 'red', 'off'); % Turn off red LED
            controlLED(a, 'yellow', 'off'); % Turn off yellow LED
        end
        
        pause(sampleRate); % Wait for the next sampling period
    end
end

% Helper function to control the state of an LED
function controlLED(a, color, state)
    % Assume predefined LED control pins are set
    % 'red', 'yellow', 'green' correspond to different Arduino digital pins
    ledPin = eval(['D' color]); % Get the pin based on color
    if strcmp(state, 'on')
        writeDigitalPin(a, ledPin, 1); % Turn on the LED
    else
        writeDigitalPin(a, ledPin, 0); % Turn off the LED
    end
end