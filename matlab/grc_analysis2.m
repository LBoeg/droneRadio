%% DARPA Hackfest
% Luke Boegner

%% Reading in GRC file
fid = fopen('downlink3.dat'); % open file
%fid = fopen('singleBurst.dat'); % open file

Fs = 14e6; % samp rate = 14M
Fc = 922e6; % center freq = 922 MHz
readsize = 10000000; % reading x number of samples
ir = 1:2:2*readsize-1;
ii = 2:2:2*readsize;
[val, count] = fread(fid, readsize*2, 'float'); % times 2 for reading I/Q data
s = complex(val(ir),-val(ii));  % put the data into a complex vector

% Want 2nd burst:
s = s(997100:1075100-1);
s = downsample(s,14);
s = s(1:5535);
Fs = Fs/14;
figure(1)
plot(abs(s))

% T = 1/Fs;             % Sampling period       
% L = length(s);        % Length of signal
% t = (0:L-1)*T;        % Time vector
% 
% S = fft(s);
% 
% P2 = abs(S/L); % Two-side spectrum
% P1 = P2(1:L/2+1); 
% P1(2:end-1) = 2*P1(2:end-1); % single side spectrum
% 
% figure(1)
% f = Fs*(0:(L/2))/L;
% plot(f, P1)
% title('Single-sided')

figure(2)
[S,w] = freqz(s);
plot(w/pi*Fs/2, abs(S));
title('Frequency Response of Recorded Data');
xlabel('Frequency (Hz)'); ylabel('Amplitude');

figure(3)
plot(s)

% fileID = fopen('singleBurst.dat','w');
% fwrite(fileID,s);
% fclose(fileID);

%% GFSK Demod

% 3DR GFSK FHSS Givens:
channel_width = (928000 - 915000) / (50+2) * 1000; % = 250000 Hz
baud = 57600;
air_speed = 64000;
freq_dev = (air_speed) * 1.2; % 76800 Hz
min_dev = 40; % kHz
max_dev = 159; % kHz

% MATLAB's 'fskdemod' function
alphabet_size = 2;
nsamp = 15; % number of samples per symbol
z = fskdemod(s,alphabet_size,freq_dev,nsamp,Fs);

% Plotting results
figure(4)
stem(z)
title('Post FSK Demod')

figure(5)
first_seg = 48;
stem(z(1:first_seg))
title('Post FSK Demod - First 48 Bits (Header Size)')
axis([0 first_seg 0 max(z)+0.1])

hdr = [1 1 1 1 1 1 1 0];
hdr_indx = strfind(z', hdr);