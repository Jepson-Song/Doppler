function res = createSignal(f0, T, fs)

t = 0:1/fs:T-1/fs;
phase = 2*pi*f0*t;
x = 5*cos(phase);

% audiowrite('18kHz.wav', x, fs);

% clear sound;
% sound(x, fs);

% subplot(2,1,1);
% plot(x);
% subplot(2,1,2);
% spectrogram(x,256,250,256,fs,'yaxis'); 
% title('createSignal')

res = x;

end