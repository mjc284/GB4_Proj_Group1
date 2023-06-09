% Initialize arduino
a = arduino();
clear a;
a = arduino();%('/dev/cu.usbserial-1410', 'Uno');
configurePin(a, 'A0', 'AnalogInput');
configurePin(a, 'A1', 'AnalogInput');

% Create figure
h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);

keyMode = 0; %0 = OOK, 1 = PWM

%two thresholds for PWM trigger hysteresis
upperThreshold = 2;
lowerThreshold = 1.9;

%slope threshold for OOK trigger
slopeThreshold = 0.2;

ookTimeOut = 7;
pwmTimeThreshold = 27.5;

x = zeros(50);
y1 = zeros(50);
y2 = zeros(50);
dy1 = zeros(50);
dy1 = zeros(50);

tic
data = 0; %1 = on, 2 = off
detecting = 0;
stateSequence = zeros(10);
timeOld = 0;

droneIsUp = 0;

while ishandle(h)

    % Detect concentration
    x = [x(2:end), toc];
    y1 = [y1(2:end), readVoltage(a,'A0')];
    y2 = [y1(2:end), readVoltage(a,'A1')];

    % Calculate derivatives
    dy1 = [dy1(2:end), (y1(end) - y1(end-1))/(x(end) - x(end-1))];
    dy2 = [dy2(2:end), (y2(end) - y2(end-1))/(x(end) - x(end-1))];

    % Plot graphs
    subplot(5,1,1);
    plot(y1);
    axis tight;
    ylim([0,5]);

    subplot(5,1,2);
    plot(dy1);
    axis tight;
    ylim([0,5]);

    subplot(5,1,3);
    plot(y2);
    axis tight;
    ylim([0,5]);

    subplot(5,1,4);
    plot(dy2);
    axis tight;
    ylim([0,5]);
    
    if keyMode == 0 %OOK
        % Detect lemon cologne with slope magnitude and update state sequence
        if detecting == 0 && max(dy1(end), dy2(end)) > slopeThreshold
            detecting = 1;
            timeOld = toc;
            stateSequence = [stateSequence(2:end), 1];
        end
    
        if detecting == 1 && ((toc - timeOld) < ookTimeOut) && ((toc - timeOld) > 1) && max(dy1(end), dy2(end)) > slopeThreshold
            timeOld = toc;
            stateSequence = [stateSequence(2:end), 1];
        end
    
        if detecting == 1 && ((toc - timeOld) > ookTimeOut)
            detecting = 0;
            timeOld = toc;
            stateSequence = [stateSequence(2:end), 0];
        end
    
        if detecting == 0 && ((toc - timeOld) > ookTimeOut)
            timeOld = toc;
            stateSequence = [stateSequence(2:end), 0];
        end
    
        % Show state sequence history
        subplot(5,1,5);
        plot(stateSequence);
        axis tight;
        ylim([-1,2]);
        
        % Detect command from state sequence and execute drone
        if isequal(stateSequence(end-4:end), [0 1 1 1 0])
            title("Up",'FontSize',20);
            if droneIsUp == 0
                writeDigitalPin(a, 'D13', 1);
                pause(0.5);
                writeDigitalPin(a, 'D13', 0);
                droneIsUp = 1;
            end
            stateSequence = [stateSequence(2:end), 0];
        elseif isequal(stateSequence(end-4:end), [0 1 1 0 0])
            title("Down", 'FontSize',20);
            if droneIsUp == 1
                writeDigitalPin(a, 'D13', 1);
                pause(2);
                writeDigitalPin(a, 'D13', 0);
                droneIsUp = 0;
            end
            stateSequence = [stateSequence(2:end), 0];
        else
            title("",'FontSize',20);
        end
    elseif keyMode == 1 %PWM
        % Detect lemon cologne pulse durations with thershold hysteresis
        if detecting == 0 && max(y1(end), y2(end)) > upperThreshold
            detecting = 1;
            timeOld = toc;
        end
    
        if detecting == 1 && max(y1(end), y2(end)) < lowerThreshold
            if ((toc - timeOld) < pwmTimeThreshold)
                stateSequence = [stateSequence(2:end), 2];
            else
                stateSequence = [stateSequence(2:end), 1];
            end
            detecting = 0;
            timeOld = toc;
        end

        if detecting == 0 && ((toc - timeOld) > 6)
            timeOld = toc;
            stateSequence = [stateSequence(2:end), 0];
        end
    
        % Show state sequence history
        subplot(3,1,3);
        plot(stateSequence);
        axis tight;
        ylim([-1,3]);
        
        % Show data state
        if isequal(stateSequence(end), 2)
            title("On",'FontSize',20);
            stateSequence = [stateSequence(2:end), 0];
        elseif isequal(stateSequence(end), 1)
            title("Off", 'FontSize',20);
            stateSequence = [stateSequence(2:end), 0];
        else
            title("",'FontSize',20);
        end
    end

    pause(0.01);

end

%clear arduino instant
clear a
