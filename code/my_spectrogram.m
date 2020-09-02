function res = my_spectrogram(y, fs, num)

[YfreqDomain,frequencyRange] = centeredFFT(y,fs);

%��Ƶ��ͼ
if num==-1
    my_stem(YfreqDomain, frequencyRange);
end
mx = 0;
fb = 0;

for(i=(int32(length(frequencyRange)/2):int32(length(frequencyRange))))
    if(abs(YfreqDomain(i))>=mx)
        fb = frequencyRange(i);
        mx = abs(YfreqDomain(i));
    end
end
%fb;
res = fb;

end

function my_stem(YfreqDomain, frequencyRange)
figure
 
%remember to take the abs of YfreqDomain to get the magnitude!
 
stem(frequencyRange,abs(YfreqDomain));
 
xlabel('Freq (Hz)')
 
ylabel('Amplitude')
 
title('FFT')

grid
%set(gca,'LooseInset',get(gca,'TightInset'))

   %RemovePlotWhiteArea(gca);

end

% RemovePlotWhiteArea: ȥ��Plot����ͼ�Ŀհײ���
% RemovePlotWhiteArea(gca)
% ����
% gca: axes���
 
% author : TSC
% time   : 2017-01-02
% email  : 292936085#qq.com(��#�滻Ϊ@)
 
function [] = RemovePlotWhiteArea(gca)
% TightInset��λ��
inset_vectior = get(gca, 'TightInset');
inset_x = inset_vectior(1);
inset_y = inset_vectior(2);
inset_w = inset_vectior(3);
inset_h = inset_vectior(4);
 
% OuterPosition��λ��
outer_vector = get(gca, 'OuterPosition');
pos_new_x = outer_vector(1) + inset_x; % ��Position��ԭ���Ƶ���TightInset��ԭ��
pos_new_y = outer_vector(2) + inset_y;
pos_new_w = outer_vector(3) - inset_w - inset_x; % ����Position�Ŀ�
pos_new_h = outer_vector(4) - inset_h - inset_y; % ����Position�ĸ�
 
% ����Position
set(gca, 'Position', [pos_new_x, pos_new_y, pos_new_w, pos_new_h]);
end
 
