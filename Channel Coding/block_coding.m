clear

M = 16;
N = 1500 * 2000;

if N < 32400
    return
end

RS.K = 5;
RS.N = 7;
RS.encoder = comm.RSEncoder('BitInput', true, 'CodewordLength', RS.N, 'MessageLength', RS.K);
RS.decoder = comm.RSDecoder('BitInput', true, 'CodewordLength', RS.N, 'MessageLength', RS.K);

Hamming.K = 11;
Hamming.N = 15;

LDPC.encoder = comm.LDPCEncoder(dvbs2ldpc(1/2));
LDPC.decoder = comm.LDPCDecoder('MaximumIterationCount',50);
LDPC.N = floor(N/32400);

PSK.mod    = comm.PSKModulator('ModulationOrder', M, 'BitInput', true);
PSK.demod  = comm.PSKDemodulator('ModulationOrder', M, 'BitOutput', true);

AWGN = comm.AWGNChannel('BitsPerSymbol', 1);

BER.LDPC.Calc = comm.ErrorRate;
BER.RS.Calc = comm.ErrorRate;
BER.AWGN.Calc = comm.ErrorRate;
BER.HAM.Calc = comm.ErrorRate;

SNR_vec = 0:15;

for i = 1:length(SNR_vec)
    reset(BER.RS.Calc)
    reset(BER.LDPC.Calc)
    reset(BER.AWGN.Calc)
    reset(BER.HAM.Calc)
    
    AWGN.EbNo = SNR_vec(i);
    data = randi([0 1], N, 1);
    
    Rx.RS = RS.decoder(PSK.demod(AWGN(PSK.mod(RS.encoder(data)))));
    Rx.AWGN =  PSK.demod(AWGN(PSK.mod(data)));
    Rx.Ham = decode(PSK.demod(AWGN(PSK.mod(encode(data, ...
    Hamming.N, Hamming.K,'hamming/binary')))), ...
    Hamming.N, Hamming.K,'hamming/binary');
    Rx.Ham = Rx.Ham(1:N);
    
    for j = 0:LDPC.N-1
        LPDCData = data((j*32400+1):((j+1)*32400));
        Rx.LDPC = LDPC.decoder(PSK.demod(AWGN(PSK.mod(LDPC.encoder(LPDCData)))));
        BER.LDPC.BER(i,:) = BER.LDPC.Calc(LPDCData, double(~Rx.LDPC));
        %disp(BER.LDPC.BER(1))
    end
    
    BER.RS.BER(i,:) = BER.RS.Calc(data, Rx.RS);
    BER.HAM.BER(i,:) = BER.RS.Calc(data, Rx.Ham);
    BER.AWGN.BER(i,:) = BER.AWGN.Calc(data,Rx.AWGN);
end
semilogy(SNR_vec, [BER.AWGN.BER(:,1) BER.RS.BER(:,1) ...
       BER.HAM.BER(:,1) BER.LDPC.BER(:,1)], 'linewidth', 0.8)
grid on
axis([0 15 -inf inf])
legend('Uncoded', 'Reed-Solomon', 'Hamming', 'LDPC', 'location', 'southwest')
title 'BER for 8-PSK in AWGN'
xlabel 'EbNo (dB)'
ylabel 'Probability of Error'
