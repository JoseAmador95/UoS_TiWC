clearvars -except models

UMa.d     = 10:50:5000; % 10 < d < 5000
UMa.Freq  = 6:100; % 0.5 < f < 100 GHz
UMa.h_BS  = 25; % Only applicable value
UMa.h_UE  = 1.5; % 1.5< h < 22.5 m

UMi.d     = 10:50:5000; % 10 < d < 5000
UMi.Freq  = 6:100; % 0.5 < f < 100 GHz
UMi.h_BS  = 10; % Only applicable value
UMi.h_UE  = 1.5; % 1.5< h < 22.5 m

RMa.d     = 10:50:5000; % d > 1
RMa.Freq  = 6:100; % 6 < f < 100 GHz
RMa.h_BS  = 35; % 0 < h < 50
RMa.h_UE  = 1.5; % 0 < h < 10

if exist('models','var') ~= 1
    UMa.fspl = fspl(UMa.d, physconst('lightspeed') ./ (UMa.Freq*1E9));
    UMi.fspl = fspl(UMi.d, physconst('lightspeed') ./ (UMi.Freq*1E9));
    RMa.fspl = fspl(RMa.d, physconst('lightspeed') ./ (RMa.Freq*1E9));
    UMa.NLOS = mmPathloss(UMa.d, UMa.Freq, UMa.h_BS, UMa.h_UE, 'UMa', 'NLOS'); 
    UMa.LOS  = mmPathloss(UMa.d, UMa.Freq, UMa.h_BS, UMa.h_UE, 'UMa', 'LOS'); 
    UMi.NLOS = mmPathloss(UMi.d, UMi.Freq, UMi.h_BS, UMi.h_UE, 'UMi', 'NLOS'); 
    UMi.LOS  = mmPathloss(UMi.d, UMi.Freq, UMi.h_BS, UMi.h_UE, 'UMi', 'LOS'); 
    RMa.NLOS = mmPathloss(RMa.d, RMa.Freq, RMa.h_BS, RMa.h_UE, 'RMa', 'NLOS'); 
    RMa.LOS  = mmPathloss(RMa.d, RMa.Freq, RMa.h_BS, RMa.h_UE, 'RMa', 'LOS');
    models = {UMa UMi RMa};
end

map = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.4660 0.6740 0.1880]};
tit = ["UMa" "UMi" "RMa"];
for m = 1:length(models)
    figure(m); clf;
    model = models{m};
    [X, Y] = meshgrid(model.d, model.Freq);
    hold on
    surf(X, Y, model.LOS', 'LineStyle','none', 'FaceColor', map{1}, 'FaceAlpha', 0.5);
    surf(X, Y, model.NLOS', 'LineStyle','none', 'FaceColor', map{2}, 'FaceAlpha', 0.5);
    surf(X, Y, model.fspl', 'LineStyle','none', 'FaceColor', map{3}, 'FaceAlpha', 0.5);
    title(tit(m))
    xlabel 'Distance (m)'
    ylabel 'Frequency (GHz)'
    zlabel 'Path Loss (dB)'

    hold off
    grid on
    legend('LOS', 'NLOS', "FS")
end