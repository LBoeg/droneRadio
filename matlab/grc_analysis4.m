%% DARPA Hackfest
% Luke Boegner

%% Reading in GRC file
fid = fopen('bi_5channel_8Msamp.dat'); % open file
Fs = 8e6; % samp rate = 8M
Fc = 919.655e6; % center freq = 919.655 MHz
readsize = 20000000; % reading x number of samples
ir = 1:2:2*readsize-1;
ii = 2:2:2*readsize;
[val, count] = fread(fid, readsize*2, 'float'); % times 2 for reading I/Q data
s = complex(val(ir),-val(ii));  % put the data into a complex vector

%s = s(5.6e6:end);

figure(1)
plot(abs(s))
title('Bursty Recorded Signal');
xlabel('Samples'); ylabel('Amplitude');

%% Burst Detector
thres = 0.02;
%indicesBelow = find(abs(s)<thres);
%s(indices) = [];
bursts = [];
burstCnt = 0;
currState = 0;
indx = 1;
for i = 1:length(s)
    if abs(s(i)) > thres
        currState = 1;
        bursts(burstCnt+1,indx) = s(i);
        indx = indx + 1;
    else
        if currState == 1
            burstCnt = burstCnt + 1;
        end
        currState = 0;
        indx = 1;
    end
end

figure(2)
fskBursts = diff(unwrap(angle(bursts')));
plot(fskBursts(:,3));

% figure(2)
% [S,w] = freqz(s,512,'whole');
% plot(w/pi*Fs/2, abs(S));
% title('Frequency Response of Recorded Data');
% xlabel('Frequency (Hz)'); ylabel('Amplitude');
% 
% scatterplot(s)
% 
% figure(4)
% spectrogram(s,16,4,16,Fs,'reassigned','centered','yaxis');

figure(5)
phaseS = diff(unwrap(angle(s)));
plot(phaseS);


% varS = movvar(phaseS,100);
% figure(6)
% plot(varS)

% pos_indx = find(phaseS>0);
% neg_indx = find(phaseS<0);
% phaseS(pos_indx) = 1;
% phaseS(neg_indx) = -1;
% figure(6)
% plot(phaseS)
% axis([0 500 -1.1 1.1])
% 
% data = [];
% posCnt = 0;
% negCnt = 0;
% window = 13;
% for i=1:length(phaseS)
%     if phaseS(i) == 1
%         posCnt = posCnt + 1;
%         negCnt = 0;
%     else
%         negCnt = negCnt + 1;
%         posCnt = 0;
%     end
%     if posCnt == window
%         data = [data 1];
%         posCnt = 0;
%         negCnt = 0;
%     end
%     if negCnt == window
%         data = [data 0];
%         posCnt = 0;
%         negCnt = 0;
%     end
% end
% figure(7)
% stem(data)
% axis([0 16 0 1.1])
% 
% % In case mapping is backwards
% dataInv = -1.*data+1;
% 
% % Find HDR 0xFE
% hdr = [1 1 1 1 1 1 1 0];
% hdr_indx = strfind(data, hdr);
% hdr_indxInv = strfind(dataInv, hdr);
% 
% % Find SYS ID (GCS=255=0xFE / VEH=1=0x01)
% for i = 1:length(hdr_indxInv)
%     sysInv = dataInv(hdr_indxInv(i)+24-4:hdr_indxInv(i)+24+7-4)
% end
% 
% for i = 1:length(hdr_indx)
%     sys = data(hdr_indx(i)+24-4:hdr_indx(i)+24+7-4)
% end
% 

% figure(6)
% thresF = 0.3;
% indices = find(abs(phaseS)<thresF);
% phaseS(indices) = [];
% thresFmax = 0.6;
% indices = find(abs(phaseS)>thresFmax);
% phaseS(indices) = [];
% plot(phaseS)

%% GFSK Demod

% % 3DR GFSK FHSS Givens:
% channel_width = (928000 - 915000) / (50+2) * 1000; % = 250000 Hz
% baud = 57600;
% air_speed = 64000;
% freq_dev = (air_speed) * 1.2; % 76800 Hz
% min_dev = 40; % kHz
% max_dev = 159; % kHz
% 
% % MATLAB's 'fskdemod' function
% alphabet_size = 2;
% nsamp = ceil(Fs/air_speed); % number of samples per symbol
% z = fskdemod(phaseS,alphabet_size,freq_dev,nsamp,Fs);
% 
% % Plotting results
% figure(6)
% stem(z)
% title('Post FSK Demod')
% 
% figure(7)
% first_seg = 48;
% stem(z(1:first_seg))
% title('Post FSK Demod - First 48 Bits (Header Size)')
% axis([0 first_seg 0 max(z)+0.1])

%%
fclose(fid);