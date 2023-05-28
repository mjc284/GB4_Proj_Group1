load('commandNet.mat') %loads the pretrained network
fs = 16e3;
classificationRate = 20;
adr = audioDeviceReader('SampleRate',fs,'SamplesPerFrame',floor(fs/classificationRate));

audioBuffer = dsp.AsyncBuffer(fs);

labels = trainedNet.Layers(end).Classes;
YBuffer(1:classificationRate/2) = categorical("background");

probBuffer = zeros([numel(labels),classificationRate/2]);

countThreshold = ceil(classificationRate*0.2);
probThreshold = 0.7;

%initialize arduino
a = arduino();
clear a;
a = arduino();%('/dev/cu.usbmodem141401', 'Uno');
configurePin(a, 'D13', 'DigitalOutput');
writeDigitalPin(a, 'D13', 0);


%turn on sprayer
pause(2);
writeDigitalPin(a, 'D13', 1);
pause(2);
writeDigitalPin(a, 'D13', 0);
pause(0.3);
writeDigitalPin(a, 'D13', 1);
pause(0.3);
writeDigitalPin(a, 'D13', 0);

keyMode = 0; %0 = OOK, 1 = PWM

%initiate figure display
h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);

timeLimit = inf;

tic
ymd = [];
out = 0;
r = 0;

oldYMode = "background";

while ishandle(h) && toc < timeLimit

    % Extract audio samples from the audio device and add the samples to
    % the buffer.
    x = adr();
    write(audioBuffer,x);
    y = read(audioBuffer,fs,fs-adr.SamplesPerFrame);

    spec = helperExtractAuditoryFeatures(y,fs);
    
    % Classify the current spectrogram, save the label to the label buffer,
    % and save the predicted probabilities to the probability buffer.
    [YPredicted,probs] = classify(trainedNet,spec,'ExecutionEnvironment','cpu');
    YBuffer = [YBuffer(2:end),YPredicted];
    probBuffer = [probBuffer(:,2:end),probs(:)];


    % Plot the current waveform and spectrogram.
    subplot(2,1,1)
    plot(y)
    axis tight
    ylim([-1,1])

    subplot(2,1,2)
    pcolor(spec')
    caxis([-4 2.6445])
    shading flat

    % Now do the actual command detection by performing a very simple
    % thresholding operation. Declare a detection and display it in the
    % figure title if all of the following hold: 1) The most common label
    % is not background. 2) At least countThreshold of the latest frame
    % labels agree. 3) The maximum probability of the predicted label is at
    % least probThreshold. Otherwise, do not declare a detection.
    [YMode,count] = mode(YBuffer);

    maxProb = max(probBuffer(labels == YMode,:));
    subplot(2,1,1);


    if YMode == "background" || count < countThreshold || maxProb < probThreshold
        title("",'FontSize',20)
    else
        title(string(YMode),'FontSize',20)
    end

    if YMode ~= oldYMode
        if keyMode == 0
            if YMode == "up" %OOK 2 Pulses
                writeDigitalPin(a, 'D13', 1);
                pause(0.1);
                writeDigitalPin(a, 'D13', 0);
                pause(0.05);
                writeDigitalPin(a, 'D13', 1);
                pause(0.05);
                writeDigitalPin(a, 'D13', 0);
                pause(6);
                writeDigitalPin(a, 'D13', 1);
                pause(0.1);
                writeDigitalPin(a, 'D13', 0);
                pause(0.05);
                writeDigitalPin(a, 'D13', 1);
                pause(0.05);
                writeDigitalPin(a, 'D13', 0);
                pause(6);
                writeDigitalPin(a, 'D13', 1);
                pause(0.1);
                writeDigitalPin(a, 'D13', 0);
                pause(0.05);
                writeDigitalPin(a, 'D13', 1);
                pause(0.05);
                writeDigitalPin(a, 'D13', 0);
                pause(12);
            elseif YMode == "down" %OOK 1 Pulse
                writeDigitalPin(a, 'D13', 1);
                pause(0.1);
                writeDigitalPin(a, 'D13', 0);
                pause(0.05);
                writeDigitalPin(a, 'D13', 1);
                pause(0.05);
                writeDigitalPin(a, 'D13', 0);
                pause(6);
                writeDigitalPin(a, 'D13', 1);
                pause(0.1);
                writeDigitalPin(a, 'D13', 0);
                pause(0.05);
                writeDigitalPin(a, 'D13', 1);
                pause(0.05);
                writeDigitalPin(a, 'D13', 0);
                pause(18);
               
            end
        else
            if YMode == "up" %PWM long pulse
                writeDigitalPin(a, 'D13', 1);
                pause(0.1);
                writeDigitalPin(a, 'D13', 0)
                pause(0.2);
                writeDigitalPin(a, 'D13', 1);
                pause(0.05);
                writeDigitalPin(a, 'D13', 0);
                pause(6);
            elseif YMode == "down" %PWM short pulse
                writeDigitalPin(a, 'D13', 1);
                pause(0.1);
                writeDigitalPin(a, 'D13', 0);
                pause(0.05);
                writeDigitalPin(a, 'D13', 1);
                pause(0.05);
                writeDigitalPin(a, 'D13', 0);
                pause(6);
            end
        end
    end
    oldYMode = YMode;

    drawnow
end

%turn off sprayer
writeDigitalPin(a, 'D13', 1);
pause(2);
writeDigitalPin(a, 'D13', 0);

%clear arduino instant
clear a