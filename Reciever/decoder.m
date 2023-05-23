

function [y] = decoder(x, x_old, dt)
    y = (x - x_old)/dt;
end

