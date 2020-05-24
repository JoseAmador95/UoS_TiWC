semilogy(cell2mat(Fad.data(1)), cell2mat(Fad.data(2)),...
         cell2mat(N64.data(1)), cell2mat(N64.data(2)),'-d',...
         cell2mat(N1024.data(1)), cell2mat(N1024.data(2)),'-o',...
         'linewidth', 1.2)
xlabel 'EbNo (dB)'
ylabel 'BER'
title 'BER for BPSK + OFDM over AWGN channel'
legend('No OFDM', 'FFT 64', 'FFT 1024', 'FFT 65536', 'location', 'southwest')
grid on
axis([0 12 10^-10 0.5])