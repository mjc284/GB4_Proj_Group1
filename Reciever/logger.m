


%initialize arduino
a = arduino();
clear a;
a = arduino();%('/dev/cu.usbserial-1410', 'Uno');
configurePin(a, 'A0', 'AnalogInput');

%create figure
h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);
x = zeros(50);
y = zeros(50);
dy = zeros(50);
tic
while ishandle(h)

    x = [x(2:end), toc];
    y = [y(2:end), readVoltage(a,'A0')];

    % Plot the current waveform and spectrogram.
    subplot(2,1,1);
    plot(y);
    axis tight;
    ylim([0,5]);

    dy = [dy(2:end), (y(end) - y(end-1))/(x(end) - x(end-1))];

    subplot(2,1,2);
    plot(dy);
    axis tight;
    ylim([0,5]);

    pause(0.01);

end

z = [transpose(x), transpose(y), transpose(dy)];

writematrix(z, 'data/dx30cm8s.csv')

%clear arduino instant
clear a
