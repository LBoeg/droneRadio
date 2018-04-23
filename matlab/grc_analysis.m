%% DARPA Hackfest
% Luke Boegner

%% Reading in GRC file
fid = fopen('downlink2.dat'); % open file
Fs = 14e6; % samp rate = 14M
Fc = 922e6; % center freq = 922 MHz
readsize = 10000000; % reading x number of samples
ir = 1:2:2*readsize-1;
ii = 2:2:2*readsize;
[val, count] = fread(fid, readsize*2, 'float'); % times 2 for reading I/Q data
s = complex(val(ir),-val(ii));  % put the data into a complex vector

%% Plotting
figure(1)
plot(abs(s))
title('Bursty Recorded Signal');
xlabel('Samples'); ylabel('Amplitude');

figure(2)
[S,w] = freqz(s);
plot(w/pi*Fs/2, abs(S));
title('Frequency Response of Recorded Data');
xlabel('Frequency (Hz)'); ylabel('Amplitude');

% After discovering the first burst occurs around samples 388e3 to 468e3,
% hone in on that section.
start1_samp = 388100;
stop1_samp = 467900;
num_samp1 = stop1_samp - start1_samp;

start2_samp = 998000;
stop2_samp = 1074000;
num_samp2 = stop2_samp - start2_samp;

s = s(start1_samp:stop1_samp-1);

figure(3)
[S,w] = freqz(s);
plot(w/pi*Fs/2, abs(S));
title(['Frequency Response of Recorded Data over ' num2str(num_samp1) ' Samples']);
xlabel('Frequency (Hz)'); ylabel('Amplitude');

figure(4)
plot(abs(s))
title('Burst of Above Segment');
axis([0 length(abs(s)) 0 0.045])

scatterplot(s)

figure(6)
phaseS = diff(unwrap(angle(s)));
plot(phaseS)

%% Mix down to baseband

% n = 1:length(s);
% mix = sin(2*pi*0.5*n);
% figure(6)
% plot(mix)
% 
% baseband = conv(s,mix);
% figure(7)
% plot(baseband)
% 
% [BB, w] = freqz(baseband);
% figure(8)
% plot(w/pi*Fs/2, abs(BB));
% 
% scatterplot(baseband)

%% GFSK Demod

% 3DR GFSK FHSS Givens:
% channel_width = (928000 - 915000) / (50+2) * 1000; % = 250000 Hz
% baud = 57600;
% air_speed = 64000;
% freq_dev = (air_speed) * 1.2; % 76800 Hz
% min_dev = 40; % kHz
% max_dev = 159; % kHz
% 
% % MATLAB's 'fskdemod' function
% alphabet_size = 2;
% nsamp = 200; % number of samples per symbol
% z = fskdemod(s,alphabet_size,freq_dev,nsamp,Fs);
% 
% % Plotting results
% figure(5)
% stem(z)
% title('Post FSK Demod')
% 
% figure(6)
% first_seg = 48;
% stem(z(1:first_seg))
% title('Post FSK Demod - First 48 Bits (Header Size)')
% axis([0 first_seg 0 max(z)+0.1])

%%
fclose(fid);