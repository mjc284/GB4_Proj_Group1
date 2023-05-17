%initialize arduino
a = arduino();
clear a;
a = arduino();%('/dev/cu.usbserial-1410', 'Uno');
configurePin(a, 'A0', 'AnalogInput');

%create figure
h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);

keyMode = 0; %0 = OOK, 1 = PWM

%two thresholds for trigger hysteresis
upperThreshold = 4.7;
lowerThreshold = 4.5;

pulseWidthThreshold = 30;

y = zeros(10);
data = 0; %1 = on, 2 = off
timer = 0;
currentState = 0;
oldState = 0;
stateSequence = zeros(4);
while ishandle(h) && toc < timeLimit

    y = [y(2:end), readVoltage(a,'A0')];

    % Plot the current waveform and spectrogram.
    subplot(2,1,1);
    plot(y);
    axis tight;
    ylim([0,5]);

    pause(0.01);
    
    % Detect lemon cologne with hysteresis
    if oldState == 0 && y(end) < lowerThreshold
        currentState = 1;
    elseif oldState == 1 && y(end) > upperThreshold
        currentState = 0;
    end

    % Update state sequence history
    if currentState ~= oldstate || timer > pulseWidthThreshold
        stateSequence = [stateSequence(2:end), currentState];
        timer = 0;
    end

    % Show state sequence history
    subplot(2,1,2);
    plot(stateSequence);
    axis tight;
    ylim([0,1]);
    xlim([0,4]);
    
    % Decode data based on OOK or PWM
    if keyMode == 0
        if isequal(stateSequence, [1 0 1 0])
            data = 1;
        elseif isequal(stateSequence, [1 0 0 0])
            data = 2;
        else
            data = 0;
        end
    elseif keyMode == 1
        if isequal(stateSequence(2:end), [1 1 0])
            data = 1;
        elseif isequal(stateSequence(2:end), [1 0 0])
            data = 2;
        else
            data = 0;
        end
    end

    % Show data state
    if data == 1
        title("On",'FontSize',20);
    elseif data == 2
        title("Off", 'FontSize',20);
    else
        title("",'FontSize',20);
    end

    % Update
    oldState = currentState;
    timer = timer + 1;
end

%clear arduino instant
clear a
