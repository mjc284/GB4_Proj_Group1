n = 100;
TR = None;
%set to be time of response
bittrain = randi(2,n,1)-1;
a= arduino;
x = 0;
g = None;
%set g to be some time which will limit ISI
while x < 100
   writeDigitalPin(a,'D13',bittrain[x]);
   pause (g)
   x = x+1;
end 
