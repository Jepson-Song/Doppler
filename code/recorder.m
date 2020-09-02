function aa= recorder()
%RECORDER Summary of this function goes here
% Detailed explanation goes here
% % h=figure(soundrec);
% 
% h=cf;
% thehandles=handles;
% setappdata(h,'isrecording',1);

a = 1

Ai=analoginput('winsound'); % 创建一个模拟信号输入对象
% 添加通道
addchannel(Ai,1);
Ai.SampleRate=48000; % 采样频率
Ai.SamplesPerTrigger=Inf; % 采样数

a = 2

start(Ai); % 开启采样
warning off % 当采样数据不够时，取消警告
while isrunning(Ai) % 检查对象是否仍在运行
    if getappdata(h,'isrecording')
        data=peekdata(Ai,Ai.SampleRate);% 获取对象中的最后Ai.SampleRate个采样数据
        plot(thehandles.axes1,data) % 绘制最后Ai.SampleRate个采样数据的图形，因此表现出来就是实时的了
        set(handles.axes1,'ylim',[-1 1],'xlim',[0 Ai.SampleRate]);
        y1=fft(data,2048); %对信号做2048点FFT变换
        f=Ai.SampleRate*(0:1023)/2048;
        bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g') %做原始语音信号的FFT频谱图
        set(handles.axes2,'ylim',[0 10],'xlim',[0 20000]);%设置handles.axes2的横纵坐标范围
        drawnow; % 刷新图像
    else
        stop(Ai);
        num=get(Ai,'SamplesAvailable');
        aa=getdata(Ai,num);
        axes(thehandles.axes1);
        plot(thehandles.axes1,aa) % 绘制所有采样数据的图形

        y1=fft(data,2048); %对信号做2048点FFT变换
        f=Ai.SampleRate*(0:1023)/2048;
        bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g') %做原始语音信号的FFT频谱图
        %set(handles.axes2,'ylim',[0 10],'xlim',[0 20000]);%设置handles.axes2的横纵坐标范围
        drawnow; % 刷新图像
        setappdata(h,'sounds',aa);
    end
end