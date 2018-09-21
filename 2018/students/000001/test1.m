

fid = fopen('../../data/1520309088000.dat','rb');
d = fread(fid,inf,'short');
fclose(fid);
% subplot(211);plot(d);
% subplot(211);plot(d(1000:4000));
fmaxd=5;%截止频率为5Hz
fs=250;%采样率250
fmaxn=fmaxd/(fs/2);
[b,a]=butter(1,fmaxn,'low');
dd=filtfilt(b,a,d);%通过5Hz低通滤波器的信号
cc=d-dd;          %去除这一段信号，得到去基线漂移的信号
%绘图
subplot(2,1,1),plot(d(1000:4000),'b');
subplot(2,1,2),plot(cc(1000:4000),'b');
