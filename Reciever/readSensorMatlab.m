
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
