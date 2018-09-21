fid = fopen('1520309088000.dat','rb');
ECG_data = fread(fid,inf,'short');
fclose(fid);
f=1;
fs=250; %采样率
Wn=2*f/fs;
[b,a]=butter(2,Wn,'low');   %2阶巴特沃斯低通系数
y=filtfilt(b,a,ECG_data);   %0相移滤波
ECG_filter1=ECG_data-y;          
%绘图
subplot(2,1,1),plot(ECG_data(1000:5000),'b');
subplot(2,1,2),plot(ECG_filter1(1000:5000),'b');


