function res = my_read(rcvPath, filename)
[rcvPath,filename]
[data, fs] = audioread([rcvPath,filename]);
%plot(data);
[m, n] = size(data);
if(n==2)
    data = data(:,1);
end
res = data;
%plot(data);
end