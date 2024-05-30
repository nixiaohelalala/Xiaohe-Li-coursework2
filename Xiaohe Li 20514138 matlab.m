%Xiaohe Li_20514138.m
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

a=arduino();duration=600;
temperature_data=zeros(duration,1);
TC=10
V_0c=0.5
for i=1:duration
A0 voltage=readVoltage(a,'A');
temperature=(A0_voltage-V_0c)*1000/TC;
temperature_data(i)=temperature;
pause(0.5);
end

% collect data
for i = 1:duration
    A0 voltage=readVoltage(a,'A');
    temperature=(A0_voltage-V_0c)*1000/TC;
    temperature_data(i)=temperature;
    pause(0.5); % wait for 0.5second
end

% Calculate and write statistics
minTemp = min(temperature_Data);
maxTemp = max(temperature_Data);
avgTemp = mean(temperature_Data);

%temperature/time plot
time = 0:duration-1;
plot(time, temperature_Data);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Cabin Temperature Over Time');

% Format the output to the screen
disp('Data logging initiated-30/5/2024');
disp('Location-Nottingham');
disp('');
zero=sprintf('Minutet0snTemperaturet0')
    disp(zero);

    for minute=1:(duration/60)
a=sprintf('Minutet %d s',minute);
b=sprintf('Temperaturelt\n%.2fC',temperature_data(minute*60));
disp(a);
disp(b);
end

maxTemp=sprintf('Maxtemp\t%.2f ',maxTemp);
minTemp=sprintf('Min temp\t %.2f c',minTemp);
avgTemp=sprintf('Average temp\t%.2f c',avgTemp);
disp(maxTemp);
disp(minTemp);
disp(avgTemp);
disp('');
disp('Data logging terminated');

%fprintf
fileId=fopen('cabin temperature.txt','W');
fprintf(fileId,'Data logging initiated-30/5/2024');
fprintf(fileId,'Location-Nottingham\n');
for i=1:duration(data)
    fprintf(fileId,'Minute %d\nTemperature %.2f cn\n',i-1, data(i));
end
fprintf(fileid,'Max temp %.2f CinMin temp %.2f c\nAverage temp %.2f c\n',maxTemp, minTemp, avgTemp)
fprintf(fielId,'Data logging terminated\n');
fclose(fileId);
clear

% close the file
fclose(fileID);

%%TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION

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

a = Arduino('COM3', 'UNO');
% initialize Arduino

% Placeholder for the actual temperature reading function
% You should replace this with the actual code that reads the sensor
function temp = readTemperature(a)
    sensorPin = 'A0';
    voltage = analogRead(a, sensorPin);
    temp = (sensorValue - 0.5) * 100; % Convert the voltage to temperature
end