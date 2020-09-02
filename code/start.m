function start()
close all;

%��ʼƵ��
f0 = 16000;
%���Ƶ��
f1 = 22500;
%chirp����
B = f1-f0;
%chirp����
T = 0.01;
fs = 48000;
%��ʱ��
sndTime = 60;
%chirp����
n = sndTime/T;
%����
c = 340;
%�ֱ��ʣ�ÿ���Ӷ�λ���ٴΣ�
rate = 100;

%��������ź�
disp('��������ź�')
address = 'E:\WorkSpace\project\test';
directoryName = input('Enter the filename: ');
directory = [address,'\',directoryName]
wavName = [directoryName, '.wav']
yr = my_read([directory,'\'], wavName);

%ת��Ϊ������
yr = yr';
whos yr
lr = length(yr);
rcvTime = lr/fs


ys = createFMCW(f0, B, T, fs, rcvTime/T);

%����
if(length(ys)<length(yr))
    ys = [ys, zeros(1, length(yr)-length(ys))];
else 
    ys = ys(1:length(yr));
end
whos ys
whos yr

figure
plot(yr)
title('�˲�ǰ yr')


%%%%%%%%%%%%%%%%%%%%%%%% �˲� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ����Ĳ������ݣ� rcd_2020-05-25_212807 16~22.5kHz 48kHz

% ��ͨ�˲���
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


disp('����fb')
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
% �������
dis_1 = c*fb*T/B;

% ��ͼ
figure
plot(dis_1,'r.-')
grid on
title('�˲���ľ���')
axis([-inf inf 0 3])
ylabel('���루�ף�')

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
% �������
dis_2 = c*fb*T/B;

% ��ͼ
figure
plot(dis_2,'r.-')
grid on
title('ym new')
axis([-inf inf 0 3])
ylabel('���루�ף�')



end
