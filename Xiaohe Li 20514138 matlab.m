%Xiaohe Li
%ssyxl24@nottingham.edu.cn

%%PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION

% initialize Arduino
a = Arduino('COM3', 'UNO');

% Connect the temperature sensor to the Arduino's A0 analog input channel
sensorPin = 'A0';
greenLEDPin = 'D2';
yellowLEDPin = 'D3';
redLEDPin = 'D4';

% Turn all LEDs off at the beginning
writeDigitalPin(a, ['a' num2str(greenLEDPin)], 0);
writeDigitalPin(a, ['a' num2str(yellowLEDPin)], 0);
writeDigitalPin(a, ['a' num2str(redLEDPin)], 0);

% Read analog value
voltage = analogRead(a, sensorPin);

%%TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE 

% Initializes the data acquisition variable
duration = 600; % 10minutes
timeInterval = 1; % Time interval to read data from sensor in seconds
numReadings = duration / timeInterval; % Number of readings to take
voltageData = zeros(1, duration);

% collect data
for i = 1:duration
    voltageData(i) = analogRead(a, sensorPin);
    pause(1); % wait for 1 second
end

% Convert voltage values to temperature values (formula needs to be adjusted according to sensor characteristics)
% Assume that V0°C is the voltage at 25°C and TC is the temperature coefficient
V0°C = 0.750; % assumed value
TC = 10; % The assumed value, the voltage change per degree Celsius
temperatureData = (voltageData / 1023 * 5 - V0°C) / TC;

time = 0:duration-1;
plot(time, temperatureData);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Cabin Temperature Over Time');

% Format the output to the screen
for i = 1:duration
    fprintf('Minute %d: Temperature %.2f °C\n', i, temperatureData(i));
end

% open the file ready to write
fileID = fopen('cabin_temperature.txt', 'w');

% write down statics
for i = 1:duration
    fprintf(fileID, 'Minute %d: Temperature %.2f °C\n', i, temperatureData(i));
end

% Calculate and write statistics
minTemp = min(temperatureData);
maxTemp = max(temperatureData);
avgTemp = mean(temperatureData);
fprintf(fileID, 'Max temp %.2f C\nMin temp %.2f C\nAverage temp %.2f C\n', maxTemp, minTemp, avgTemp);

% close the file
fclose(fileID);

%%TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION

% The LED is connected to the Arduino's digital channel
greenLEDPin = 'D2';
yellowLEDPin = 'D3';
redLEDPin = 'D4';

% Turn all LEDs off at the beginning
writeDigitalPin(a, ['a' num2str(greenLEDPin)], 0);
writeDigitalPin(a, ['a' num2str(yellowLEDPin)], 0);
writeDigitalPin(a, ['a' num2str(redLEDPin)], 0);

function temp_monitor(a, greenLEDPin, yellowLEDPin, redLEDPin)
    %Continuous temperature monitoring
    while true
        currentTemp = readTemperature(a); % Suppose readTemperature is a function that reads the temperature
        if currentTemp >= 18 && currentTemp <= 24
            writeDigitalPin(a, ['a' num2str(greenLEDPin)], 1);
            writeDigitalPin(a, ['a' num2str(yellowLEDPin)], 0);
            writeDigitalPin(a, ['a' num2str(redLEDPin)], 0);
        elseif currentTemp < 18
            writeDigitalPin(a, ['a' num2str(greenLEDPin)], 0);
            writeDigitalPin(a, ['a' num2str(yellowLEDPin)], 1);
            % yellow blinking
        else % currentTemp > 24
            writeDigitalPin(a, ['a' num2str(greenLEDPin)], 0);
            writeDigitalPin(a, ['a' num2str(redLEDPin)], 1);
            % red blinking
        end
        pause(1); % check temperature every second
    end
end

%%TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION

function temp_prediction(a)
    % initialize variables
    sampleRate = 1; % Sample once per second
    predictionTime = 300; % 5-minute forecast
    temperatureData = zeros(1, predictionTime);
    
    % collect data
    for i = 1:predictionTime
        temperatureData(i) = readTemperature(a); % Suppose readTemperature is a function that reads the temperature
        pause(sampleRate);
    end
    
    % Calculate the rate of temperature change
    rateOfChange = diff(temperatureData) / sampleRate;
    
    % Predict the temperature in 5 minutes
    currentTemp = temperatureData(end);
    expectedTemp = currentTemp + rateOfChange * predictionTime;
    
    % output result
    fprintf('Current temperature: %.2f °C\n', currentTemp);
    fprintf('Expected temperature in 5 minutes: %.2f °C\n', expectedTemp);
    
    % Control LED indicates temperature change
    if rateOfChange > 0.07 % larger than 4°C/min
        writeDigitalPin(a, 'D4', 1); % red
    elseif rateOfChange < -0.07 % smaller than -4°C/min
        writeDigitalPin(a, 'D3', 1); % yellow
    else
        writeDigitalPin(a, 'D2', 1); % green
    end
end

%reflective statement

%The primary challenge was integrating Matlab programming with Arduino hardware, 
% particularly in converting analog signals to digital for accurate temperature readings.
%Real-time data visualization and LED control logic in Task 2 also posed significant hurdles
%Despite these challenges,I learned to effectively allocate time and
%resources to meet deadlines.
%limitation is the model is hard to use in reality. And the initial lack of
%familiarity with Git for version control.
%for future improvement,I plan to deepen my understanding of version control systems and enhance my skills in real-time data processing. 
% I also aim to explore advanced predictive algorithms to improve accuracy in sensor data analysis.

%%TASK5

% initialize Arduino
a = Arduino('COM3', 'UNO');

% Placeholder for the actual temperature reading function
% You should replace this with the actual code that reads the sensor
function temp = readTemperature(a)
    sensorPin = 'A0';
    voltage = analogRead(a, sensorPin);
    temp = (sensorValue - 0.5) * 100; % Convert the voltage to temperature
end