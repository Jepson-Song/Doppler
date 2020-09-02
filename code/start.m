function start()
close all;

%初始频率
f0 = 16000;
%最高频率
f1 = 22500;
%chirp带宽
B = f1-f0;
%chirp周期
T = 0.01;
fs = 48000;
%总时长
sndTime = 60;
%chirp个数
n = sndTime/T;
%声速
c = 340;
%分辨率（每秒钟定位多少次）
rate = 100;

%读入接收信号
disp('读入接收信号')
address = 'E:\WorkSpace\project\test';
directoryName = input('Enter the filename: ');
directory = [address,'\',directoryName]
wavName = [directoryName, '.wav']
yr = my_read([directory,'\'], wavName);

%转置为行向量
yr = yr';
whos yr
lr = length(yr);
rcvTime = lr/fs


ys = createFMCW(f0, B, T, fs, rcvTime/T);

%对齐
if(length(ys)<length(yr))
    ys = [ys, zeros(1, length(yr)-length(ys))];
else 
    ys = ys(1:length(yr));
end
whos ys
whos yr

figure
plot(yr)
title('滤波前 yr')


%%%%%%%%%%%%%%%%%%%%%%%% 滤波 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 优秀的测试数据： rcd_2020-05-25_212807 16~22.5kHz 48kHz

% 带通滤波器
yr = bandpass(f0, f1, yr, fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ym = ys.*yr;

figure
plot(ys)
title('ys')
figure
plot(yr)
title('yr')
figure
plot(ym)
title('ym')


disp('计算fb')
fb = [];
for(i=(1:fs/rate:T*n*fs))
    if(i+fs/rate-1>length(ym))
        break
    end
    ym_now = ym(i:i+fs/rate-1);
%     if(i>1)
%         ym_now = ym_now - ym_last;
%     end
    tmp = my_spectrogram(ym_now, fs, i);
    fb = [fb, tmp];
    ym_last = ym_now;
end
% 计算距离
dis_1 = c*fb*T/B;

% 画图
figure
plot(dis_1,'r.-')
grid on
title('滤波后的距离')
axis([-inf inf 0 3])
ylabel('距离（米）')

ym_new = [];
fb=[];
for(i=(1:fs/rate:T*n*fs))
    if(i+fs/rate-1>length(ym))
        break
    end
    ym_now = ym(i:i+fs/rate-1);
    if(i>1)
        ym_now = ym_now - ym_last;
    end
    tmp = my_spectrogram(ym_now, fs, i);
    fb = [fb, tmp];
    ym_last = ym_now;
    ym_new = [ym_new, ym_now];
end

figure
plot(ym_new)
title('ym new')
% 计算距离
dis_2 = c*fb*T/B;

% 画图
figure
plot(dis_2,'r.-')
grid on
title('ym new')
axis([-inf inf 0 3])
ylabel('距离（米）')



end
