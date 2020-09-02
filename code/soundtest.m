function soundtest()
timeLength=0.1;   % 采样时长，单位秒
fs = 48000;
samples=timeLength*fs;  % 默认采样率44100，计算采样点数
H = audioDeviceReader('SamplesPerFrame', samples);           % 采样点数
[audioIn,~] = step(H);                     % 第一次采样
figure('Name','实时频谱','MenuBar'...
    ,'none','ToolBar','none','NumberTitle','off');
xdata=(1:1:samples/2)/timeLength;          
axes1= subplot(1,2,1);
axes2= subplot(1,2,2);
pic= plot(axes1, 1:1:samples, audioIn);    % 初始化音频波形图
pic2= bar(axes2,xdata, xdata*0,'r');       % 初始化频谱图
set(axes2,'xlim', [min(xdata) max(xdata)], 'ylim',[0 1] , ...
     'XTick',[1e4 2e4 3e4],'YTick',[] ); %'xscale','log',
set(axes1,'xlim', [0 samples], 'ylim', ...
    [-0.05 0.05],'XTick',[],'YTick',[] );
xlabel(axes2,'频率 (Hz)');
xlabel(axes1,'波形');
axes2.Position=[0.040 0.48 0.92 0.48]; % 左，下，宽度，高度
axes1.Position=[0.040 0.06 0.92 0.25];
drawnow;

dis_len = 1000;
dis = zeros(1, dis_len);
figure('Name','距离');        
axes3= subplot(1,1,1);
pic3= plot(axes3, 1:1:dis_len, dis);    % 初始化距离图
drawnow;


%初始频率
f0 = 16000;
%最高频率
f1 = 22500;

%chirp带宽
B = f1-f0;
%chirp周期
T = timeLength;

c = 380;

rate = 1/T;

ys = createFMCW(f0, B, T, fs, 1/T);
num = 0;
 while 3>2
   [audioIn,Overrun] = step(H);        % 采样
   if Overrun > 0
      warning('  数据溢出 %d 位\n',Overrun);
   end
   num = num + 1;
   num = mod(num,rate);
   if (num==0)
       num = rate;
   end
   num
   audioOut = ys((num-1)*fs*T+1: num*fs*T);
   
   %带通滤波器
   audioIn = bandpass(f0, f1, audioIn, fs);
   
   audioMix = audioIn.*audioOut;
   
   tmp = my_spectrogram(audioMix, fs, i);
   %fb = [fb, tmp];
   
   
    tmp_dis = c*tmp*T/B
    
    dis = abs([dis(2:dis_len), tmp_dis]);
    
    length(dis)
    
   ydata_fft=fft(audioIn);             % 傅里叶变换
   ydata_abs=abs(ydata_fft(1:samples/2));% 取绝对值
   set(pic, 'ydata',audioIn);          % 更新波形图数据
   set(pic2, 'ydata',ydata_abs);  % 更新频谱图数据
   
%    drawnow;                            % 刷新
   
   set(pic3, 'ydata',dis);  % 更新频谱图数据
   
   drawnow;                            % 刷新
end
end