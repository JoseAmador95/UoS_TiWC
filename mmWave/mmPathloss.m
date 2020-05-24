function pathloss = mmPathloss(distance,Freq,BS_height,UE_height,environment, scenario)
    pathloss = zeros(length(distance), length(Freq));
    for d = 1:length(distance)
        for f = 1:length(Freq)
            pathloss(d,f) = getMmPathloss(distance(d),Freq(f),BS_height,UE_height,1,environment,scenario);
        end
    end
end