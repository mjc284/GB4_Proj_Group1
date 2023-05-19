n = 100;
TR = None;
%set to be time of response
bittrain = randi(2,n,1)-1;
a= arduino;
x = 0;
g = none;
h = none;
%set g and h to be some thresholds for decoding that will limit isi
while x < 100
    if bittrain(x) == 0
        writeDigitalPin(a,'D13',bittrain[x]);
        pause(g);
    else
        writeDigitalPin(a,'D13',bittrain[x]);
        pause(h);
    end
   x = x+1;
end 