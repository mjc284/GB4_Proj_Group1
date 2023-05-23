

%initialize arduino
a = arduino();
clear a;
a = arduino();%('/dev/cu.usbserial-1410', 'Uno');
configurePin(a, 'A0', 'AnalogInput');

%create figure
h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);

keyMode = 0; %0 = OOK, 1 = PWM

%two thresholds for trigger hysteresis
%upperSlopeThreshold = 2;
%lowerThreshold = 1.9;
slopeThreshold = 0.4;

pulseWidth = 50; %ms
pulseWidthThreshold = 30;

x = zeros(50);
y = zeros(50);
dy = zeros(50);
tic
data = 0; %1 = on, 2 = off
detecting = 0;
stateSequence = zeros(10);
timeOld = 0;
while ishandle(h)

    x = [x(2:end), toc];
    y = [y(2:end), readVoltage(a,'A0')];

    % Plot the current waveform and spectrogram.
    subplot(3,1,1);
    plot(y);
    axis tight;
    ylim([0,5]);

    dy = [dy(2:end), (y(end) - y(end-1))/(x(end) - x(end-1))];

    subplot(3,1,2);
    plot(dy);
    axis tight;
    ylim([0,5]);
    
    % Detect lemon cologne with slope magnitude
    if detecting == 0 && dy(end) > slopeThreshold
        detecting = 1;
        timeOld = toc;
        stateSequence = [stateSequence(2:end), 1];
    end

    if detecting == 1 && ((toc - timeOld) < 10) && ((toc - timeOld) > 1) && dy(end) > slopeThreshold
        timeOld = toc;
        stateSequence = [stateSequence(2:end), 1];
    end

    if detecting == 1 && ((toc - timeOld) > 10)
        detecting = 0;
        timeOld = toc;
        stateSequence = [stateSequence(2:end), 0];
    end

    if detecting == 0 && ((toc - timeOld) > 10)
        timeOld = toc;
        stateSequence = [stateSequence(2:end), 0];
    end

    % Show state sequence history
    subplot(3,1,3);
    plot(stateSequence);
    axis tight;
    ylim([-1,2]);
    
    % Decode data based on OOK or PWM
    %if keyMode == 0
    %    if isequal(stateSequence, [1 0 1 0])
    %        data = 1;
    %    elseif isequal(stateSequence, [1 0 0 0])
    %        data = 2;
    %    else
    %        data = 0;
    %    end
    %elseif keyMode == 1
    %    if isequal(stateSequence(2:end), [1 1 0])
    %        data = 1;
    %    elseif isequal(stateSequence(2:end), [1 0 0])
    %        data = 2;
    %    else
    %        data = 0;
    %    end
    %end

    % Show data state
    if isequal(stateSequence(end-2:end), [0 1 1 1 0])
        title("On",'FontSize',20);
    elseif isequal(stateSequence(end-2:end), [0 1 1 0 0])
        title("Off", 'FontSize',20);
    else
        title("",'FontSize',20);
    end

    pause(0.01);

end

%clear arduino instant
clear a
