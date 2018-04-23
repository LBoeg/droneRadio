M = 2;         % Modulation order
k = log2(M);   % Bits per symbol
EbNo = 5;      % Eb/No (dB)
Fs = 16;       % Sample rate (Hz)
nsamp = 8;     % Number of samples per symbol
freqsep = 10;  % Frequency separation (Hz)

data = randi([0 M-1],5000,1);

txsig = fskmod(data,M,freqsep,nsamp,Fs);

rxSig  = awgn(txsig,EbNo+10*log10(k)-10*log10(nsamp),'measured',[],'dB');

dataOut = fskdemod(rxSig,M,freqsep,nsamp,Fs);

[num,BER] = biterr(data,dataOut);

BER_theory = berawgn(EbNo,'fsk',M,'noncoherent');
[BER BER_theory]