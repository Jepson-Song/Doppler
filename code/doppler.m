function doppler()

close all;

%采样率
fs = 48000;

%信号频率
f0 = 18000;



%发射信号

%读入接收信号
disp('读入接收信号')
address = 'E:\WorkSpace\project\test';
directoryName = input('Enter the filename: ');
directory = [address,'\',directoryName];
wavName = [directoryName, '.wav'];
x = my_read([directory,'\'], wavName);

whos x;

nx = length(x);

T = nx/fs;

y_cos = createSignal(f0, T, fs);
y_sin = createSinSignal(f0, T, fs);

whos y;

% IO调制
z_cos = x'.*y_cos;
z_cos = lowpass(200, 1000, z_cos, fs);


z_sin = x'.*y_sin;


%滤波
B = 800;
f1 = f0 - B/2;
f2 = f0 + B/2;
x = bandpass(f1, f2, x, fs);

%窗长度
win_len = fs/5;%4096;%fs/5;%

%窗函数
window = hamming(win_len);

%步长
step = 128;

%重叠数
noverlap = win_len - step;

%fft长度
nfft = win_len    ;%17500:1:18500;%

figure
spectrogram(x,window,noverlap,nfft,fs,'MinThreshold',-100,'yaxis');%'MinThreshold',-100,'reassigned',
title('原始信号');
zoom on;
hold on;

% 'rcd_2020-08-19_102401' 手掌
% 'rcd_2020-08-11_175839' 人

figure
subplot(2,1,1)
plot(z_cos);
title('波形')

subplot(2,1,2)
spectrogram(z_cos,window,noverlap,nfft,fs,'MinThreshold',-100,'yaxis');%'MinThreshold',-100,'reassigned',
title('cos调制信号');
zoom on;
hold on;

% figure
% spectrogram(z_sin,window,noverlap,nfft,fs,'yaxis');%'MinThreshold',-100,'reassigned',
% title('sin调制信号');
% zoom on;
% hold on;

% figure
% spectrogram(z_cos+z_sin,window,noverlap,nfft,fs,'MinThreshold',-100,'yaxis');%'MinThreshold',-100,'reassigned',
% title('cos+sin调制信号');
% zoom on;
% hold on;
% 
% figure
% spectrogram(z_cos-z_sin,window,noverlap,nfft,fs,'MinThreshold',-100,'yaxis');%'MinThreshold',-100,'reassigned',
% title('cos-sin调制信号');
% zoom on;
% hold on;
% 
% figure
% spectrogram(-z_cos+z_sin,window,noverlap,nfft,fs,'MinThreshold',-100,'yaxis');%'MinThreshold',-100,'reassigned',
% title('-cos+sin调制信号');
% zoom on;
% hold on;
% 
% figure
% spectrogram(-z_cos-z_sin,window,noverlap,nfft,fs,'MinThreshold',-100,'yaxis');%'MinThreshold',-100,'reassigned',
% title('-cos-sin调制信号');
% zoom on;
% hold on;

%'rcd_2020-08-06_125606

% [s, f, t, p] = spectrogram(x, window,noverlap, nfft, fs,'MinThreshold',-100,'yaxis');
% figure;
% imagesc(t, f, 20*log10((abs(s))));xlabel('Samples'); ylabel('Freqency');
% colorbar;



end