function res = my_spectrogram(y, fs, num)

[YfreqDomain,frequencyRange] = centeredFFT(y,fs);

%画频谱图
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

% RemovePlotWhiteArea: 去除Plot画的图的空白部分
% RemovePlotWhiteArea(gca)
% 输入
% gca: axes句柄
 
% author : TSC
% time   : 2017-01-02
% email  : 292936085#qq.com(将#替换为@)
 
function [] = RemovePlotWhiteArea(gca)
% TightInset的位置
inset_vectior = get(gca, 'TightInset');
inset_x = inset_vectior(1);
inset_y = inset_vectior(2);
inset_w = inset_vectior(3);
inset_h = inset_vectior(4);
 
% OuterPosition的位置
outer_vector = get(gca, 'OuterPosition');
pos_new_x = outer_vector(1) + inset_x; % 将Position的原点移到到TightInset的原点
pos_new_y = outer_vector(2) + inset_y;
pos_new_w = outer_vector(3) - inset_w - inset_x; % 重设Position的宽
pos_new_h = outer_vector(4) - inset_h - inset_y; % 重设Position的高
 
% 重设Position
set(gca, 'Position', [pos_new_x, pos_new_y, pos_new_w, pos_new_h]);
end
 
