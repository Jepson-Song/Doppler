function testFFT()

%-----------------------------------------------%
%Author             :  aoxiang_ywj
%Project            :  Matlab做fft时点数N怎么选取
%Brief introduction :
%假设我们有一个信号，它含有2V的直流分量，频率为50Hz、相位为-30度、幅度为3V的交流信号，以及一个频率为75Hz、相位为90度、幅度为1.5V的交流信号。
%用数学表达式就是如下： S=2+3*cos(2*pi*50*t-pi*30/180)+1.5*cos(2*pi*75*t+pi*90/180)  
%式中cos参数为弧度，所以-30度和90度要分别换算成弧度。我们以256Hz的采样率对这个信号进行采样，总共采样256点。
%按照我们上面的分析，Fn=(n-1)*Fs/N，我们可以知道，每两个点之间的间距就是1Hz，第n个点的频率就是n-1。
%我们的信号有3个频率：0Hz、50Hz、75Hz，应该分别在第1个点、第51个点、第76个点上出现峰值，其它各点应该接近0。实际情况如何呢？ 看figure（2）
%-----------------------------------------------%
clc;
clear;
close all; %先关闭所有图片
Adc=2;  %直流分量幅度
A1=3;   %频率F1信号的幅度
A2=1.5; %频率F2信号的幅度
F1=50;  %信号1频率(Hz)
F2=75;  %信号2频率(Hz)
Fs=256; %采样频率(Hz)
P1=-30; %信号1相位(度)
P2=90;  %信号相位(度)
N=256;  %采样点数
t=[0:1/Fs:N/Fs]; %采样时刻
%Fn=(1:1:N)*Fs/N; %频域点数
 
%信号
S=Adc+A1*cos(2*pi*F1*t+pi*P1/180)+A2*cos(2*pi*F2*t+pi*P2/180);
%显示原始信号
plot(S);
title('原始信号');
 
figure;
Y = fft(S,N); %做FFT变换
Ayy = (abs(Y)); %取模
plot(Ayy(1:N));   %显示原始的FFT模值结果          与plot(Ayy);效果一样
%plot(Fn,Ayy(1:N));
title('FFT 模值');
 
figure;
Ayy=Ayy/(N/2);   %换算成实际的幅度
Ayy(1)=Ayy(1)/2;
F=([1:N]-1)*Fs/N; %换算成实际的频率值
plot(F(1:N/2),Ayy(1:N/2));   %显示换算后的FFT模值结果
title('幅度-频率曲线图');
 
figure;
Pyy=[1:N/2];
for i=1:N/2
Pyy(i)=phase(Y(i)); %计算相位
Pyy(i)=Pyy(i)*180/pi; %换算为角度
end;
plot(F(1:N/2),Pyy(1:N/2));   %显示相位图
title('相位-频率曲线图');

end