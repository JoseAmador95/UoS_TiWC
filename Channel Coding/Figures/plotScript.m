subplot(2,1,1)
Hplot =  semilogy(cell2mat(AWGN.data(1)), cell2mat(AWGN.data(2)), ...
                  cell2mat(HT.data(1)), cell2mat(HT.data(2)), ... 
                  cell2mat(HS.data(1)), cell2mat(HS.data(2)),'-.d', ...
                  'linewidth', 1.2);
axis([0 10, 10^-5 1])
grid on
legend('Uncoded', 'Theoretical', 'Simulation', 'location', 'southwest')
title 'BER for 8-PSK + Hamming(63, 5) over AWGN'
ylabel 'BER'

subplot(2,1,2)
Hplot =  semilogy(cell2mat(AWGN.data(1)), cell2mat(AWGN.data(2)), ...
                  cell2mat(RST.data(1)), cell2mat(RST.data(2)), ... 
                  cell2mat(RSS.data(1)), cell2mat(RSS.data(2)),'-.d', ...
                  'linewidth', 1.2);
axis([0 11, 10^-5 1])
grid on
legend('Uncoded', 'Theoretical', 'Simulation', 'location', 'southwest')
title 'BER for 8-PSK + RS(15, 13) over AWGN'
ylabel 'BER'
xlabel 'EB/No (dB)'