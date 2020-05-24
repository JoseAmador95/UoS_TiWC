clear
M = 5;
W = [0.1204 0.2407 0.3009 0.2407 0.1204];
ang = 0:2*pi/1000:2*pi;
F(181) = struct('cdata',[],'colormap',[]);
for steer = 0:360
    S = exp(-1i*(0:M-1)*pi.*sind(steer));
    for theta = 1:length(ang)
    x = exp(-1i*(0:M-1)*pi.*sin(ang(theta)));
    p(theta) = sum(x .* conj(W .* S)); 
    end
    polarplot(ang,abs(p))
    drawnow
    F(steer+1) = getframe;
end 
