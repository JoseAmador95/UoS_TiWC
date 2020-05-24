function pathlossValue = getMmPathloss(txRxDistance, carrierFreq,BSheight,... 
                                       UTheight, refDist, envType,sceType)
% getMmPathloss - Computes the pathloss incured by a milimeter wave signal
% transmitted over a given distance, between a Tx and Rx of specified
% heights respectively for various scenarios as specified in 3GPP TR 38.901
% V14.0.0 and updated in 3GPP TR 38.901 V16.0.0. 

% NOTE: Before calling this function, you would need to specify a seed
% value everytime by calling the rng() function with thsame choosen number
% as input (example rng(42)), to ensure consistent result.

% Inputs:
%
%      txRxDistance - distance between transmitters(Tx) and receivers(Rx) (m)
%      CarrierFreq  - Center Frequency (GHz)
%      BSheight - Transmitter height (m)
%      UEheight - Receiver height (m)
%      refDist - reference distance (m)
%      envType - environment type. e.g UMi, UMa, RMa
%      sceType - scenario type. e.g LOS, NLOS

% Output:
%      pathlossValue - pathloss value 

% --start--
    c = 3e8; % speed of light (m/s)
    m_lambda= c/(carrierFreq*1e9); % wavelength (m)

    m_dbp = 4*(BSheight-1)*(UTheight-1)/m_lambda; % break point/ cut-off distance
    
    sceEnvType = strcat(envType, sceType);
    switch sceEnvType
        %% UMi-Street LOS pathloss (dB)Based on 3GPP TR 38.901 V16.0.0 specs.
        case "UMiLOS"
            if (10 <= txRxDistance && txRxDistance <= m_dbp)
                pathlossValue = 32.4 + 21*log10(txRxDistance) + 20*log10(carrierFreq);
            end

            if (m_dbp < txRxDistance && txRxDistance <= 5000)
                pathlossValue = 32.4 + 40*log10(txRxDistance) + 20*log10(carrierFreq)...
                    - 9.5*log10(((m_dbp)^2)+(BSheight-UTheight)^2);
            end

            % using mmMagic UMi-Street Canyon LOS. TO DO: May need update
            if (txRxDistance< 10 || txRxDistance> 5000)
                pathlossValue = 32.9 + 19.2*log10(txRxDistance) + ...
                                20.8*log10(carrierFreq);
            end
            %fprintf('Executing UMi LOS PL section.\n');

        %% UMi-Street NLOS pathloss (dB)Based on 3GPP TR 38.901 V16.0.0 specs.     
        case "UMiNLOS"
            if (10 <= txRxDistance && txRxDistance <= 5000)

                if (10 <= txRxDistance && txRxDistance <= m_dbp)
                    tempPLVal_los = 32.4 + 21*log10(txRxDistance) ...
                                    + 20*log10(carrierFreq);
                end
                if (m_dbp < txRxDistance && txRxDistance <= 5000)
                    tempPLVal_los = 32.4 + 40*log10(txRxDistance) ...
                                    + 20*log10(carrierFreq)...
                                    - 9.5*log10(((m_dbp)^2)+((BSheight-1)-(UTheight-1))^2);
                end

                tempPLVal_nlos = 22.4 + 35.3*log10(txRxDistance) + 21.3*log10(carrierFreq) ...
                                 - 0.3*(UTheight-1.5);

                pathlossValue = max(tempPLVal_los, tempPLVal_nlos);
            end

            if (txRxDistance< 10 || txRxDistance> 5000)
                pathlossValue = 32.4 + 31.9*log10(txRxDistance/refDist)...
                                + 20*log10(carrierFreq);
            end
            %fprintf('Executing UMi NLOS PL section.\n');

        %% UMa LOS pathloss (dB)Based on 3GPP TR 38.901 V16.0.0 specs.    
        case "UMaLOS"
            if (10 <= txRxDistance && txRxDistance <= m_dbp)
                pathlossValue = 28.0 + 22*log10(txRxDistance) ...
                                + 20*log10(carrierFreq);
            end
            if (m_dbp < txRxDistance && txRxDistance <= 5000)
                pathlossValue = 28.0 + 40*log10(txRxDistance) ...
                                + 20*log10(carrierFreq)...
                                - 9*log10(((m_dbp)^2)+(BSheight-UTheight)^2);
            end
            %fprintf('Executing UMa LOS PL section.\n');
        %% UMa NLOS pathloss (dB)Based on 3GPP TR 38.901 V16.0.0 specs.
        case "UMaNLOS"
            if (10 <= txRxDistance && txRxDistance <= 5000)
                if (10 <= txRxDistance && txRxDistance <= m_dbp)
                    tempPLVal_los = 28.0 + 22*log10(txRxDistance) ...
                                    + 20*log10(carrierFreq);
                end
                if (m_dbp < txRxDistance && txRxDistance <= 5000)
                    tempPLVal_los = 28.0 + 40*log10(txRxDistance) ...
                                    + 20*log10(carrierFreq)...
                                    - 9*log10(((m_dbp)^2)+(BSheight-UTheight)^2);
                end
                tempPLVal_nlos = 13.54 + 39.08*log10(txRxDistance) ...
                                + 20*log10(carrierFreq) - 0.6*(UTheight-1.5);

                pathlossValue = max(tempPLVal_los, tempPLVal_nlos);              
            elseif (txRxDistance < 10 || txRxDistance > 5000)
                pathlossValue = 32.4 +20*log10(carrierFreq)...
                                +30*log10(txRxDistance);
            end
            %fprintf('Executing UMa NLOS PL section.\n');
        %% RMa LOS pathloss (dB)
        %TO DO: 3GPP TR 38.901 V16.0.0 not yet adopted
        case "RMaLOS"
            pathlossValue = 20*log10(4*pi*refDist*carrierFreq*1e9/c) + ...
                23.1*(1-0.03*((BSheight-35)/35))*log10(txRxDistance);
            %fprintf('Executing RMa LOS PL section.\n');

        %% RMa NLOS pathloss (dB)
        %TO DO: 3GPP TR 38.901 V16.0.0 not yet adopted
        case "RMaNLOS"
             pathlossValue = 20*log10(4*pi*refDist*carrierFreq*1e9/c) + ....
                    30.7*(1-0.049*((BSheight-35)/35))*log10(txRxDistance);
                %fprintf('Executing RMa NLOS PL section.\n');
        otherwise
             pathlossValue = NaN;
    end
    %fprintf('Pathloss value is %s.\n', num2str(pathlossValue));
    % --end--
end


