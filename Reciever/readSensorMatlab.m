a = arduino('/dev/cu.usbmodem14401',"Uno");
figure;
sensorLine = animatedline('Color', 'b', 'LineWidth', 2);

% Set the number of samples to plot
numSamples = 100;
xData = 1:numSamples;
yData = zeros(1, numSamples);

% Main loop for real-time plotting
while true
    % Read analog sensor data from Arduino
    sensorValue = readVoltage(a, 'A0');

    % Shift the existing data and add the new data point
    yData = circshift(yData, -1);
    yData(numSamples) = sensorValue;
    
    % Update the plot
    xlabel('Sample');
    ylabel('Sensor Value');
    title('Real-Time Sensor Data');
    grid on;
    axis([1 numSamples 0 5]);  % Adjust the axis limits if needed
    
    plot(xData, yData);
    drawnow;
end

% Close the Arduino connection
clear a;
