% Parameters
samplingRate = 1000; % Sampling rate in Hz
symbolRate = 100; % Symbol rate in Hz
rolloffFactor = 0.5; % Rolloff factor for the raised cosine filter
filterLength = 10; % Length of the filter in symbols

% Generate received signal (replace with your Arduino input)
t = 0:1/samplingRate:1; % Time vector
a = arduino; % arduino input
sensorValue = readVoltage(a, 'A0');

% Matched filter design
filterCoeffs = rcosdesign(rolloffFactor, filterLength, symbolRate); % Raised cosine filter coefficients

% Apply matched filter
filteredSignal = filter(filterCoeffs, 1, sensorValue); % Convolve received signal with the filter

% Plot signals
subplot(2,1,1);
plot(t, sensorValue);
title('Received Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filteredSignal);
title('Filtered Signal');
xlabel('Time');
ylabel('Amplitude');

eyediagram(filteredSignal,2)