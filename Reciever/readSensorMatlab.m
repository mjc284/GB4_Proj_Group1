
a = arduino('/dev/cu.usbmodem141401', 'Uno');
%configurePin(a, 'A0', 'AnalogInput');
sf = 100;
voltages = 0;
count = 0;

while count < 100
    %a0 = readVoltage(a,"A0");
    c = read(arduino, 'char');
    pause(1/sf);
    voltages = [voltages; c];
    count = count + 1;

end

plot(voltages, 1/sf * 100);

//% alternative code
// % Create Arduino object
// a = arduino('COM3');

// % Set up figure and axes for plotting
// figure;
// plotAxis = axes;
// hold on;
// sensorLine = animatedline('Color', 'b', 'LineWidth', 2);

// % Set the number of samples to plot
// numSamples = 100;
// xData = 1:numSamples;
// yData = zeros(1, numSamples);

// % Main loop for real-time plotting
// while true
//     % Read analog sensor data from Arduino
//     sensorValue = readVoltage(a, 'A0');
    
//     % Shift the existing data and add the new data point
//     yData = circshift(yData, -1);
//     yData(numSamples) = sensorValue;
    
//     % Update the plot
//     cla(plotAxis);
//     xlabel('Sample');
//     ylabel('Sensor Value');
//     title('Real-Time Sensor Data');
//     grid on;
//     axis([1 numSamples 0 5]);  % Adjust the axis limits if needed
    
//     addpoints(sensorLine, xData, yData);
//     drawnow;
// end

// % Close the Arduino connection
// clear a;

