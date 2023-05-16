
a = arduino('/dev/cu.usbmodem144401', 'Uno');
configurePin(a, 'A0', 'AnalogInput');
sf = 100;
voltages = [];
count = 0;

while count < 100
    a0 = readVoltage(a,"A0");
    pause(1/sf);
    voltages = [voltages; a0];
    count =+ 1;

end

plot(voltages, 1/sf * 100);
