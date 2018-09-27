clc;
clear;

fid = fopen('../../ss mat/data/1520309088000.dat','rb'); %打开数据文件 
sig = fread(fid,inf,'short');  %读取文件 
fclose(fid);  %关闭文件
L=length(sig);  %心电信号的总长
t=1:L;
fs=250;    %采样频率 250
fmaxd=0.5;   %截止频率 0.5   
  fmaxn = fmaxd/(fs/2);
  [b,a]= butter(1,fmaxn,'low');  % 设计巴特沃斯一阶低通滤波器 
sig1=filter(b,a,sig);   %通过0.5Hz低通滤波器的信号
sig1=sig-sig1;  %去除这一段信号，得到去基线漂移的信号
t=1/fs:1/fs:L/fs;

%绘图
subplot(211);plot(t,sig,'k');
xlabel('Time(s)');ylabel('ECG(mv)');xlim([200 210]);title('原始信号');
subplot(212);plot(t,sig1,'k');
xlabel('Time(s)');ylabel('ECG1(mv)');xlim([200 210]);title('巴特沃斯低通滤波后的信号');