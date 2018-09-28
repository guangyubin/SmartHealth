clc;
clear;
fid = fopen('100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);
L = length(sig);
Fs = 250; %采样频率
Ts = 1/Fs; %采样周期
[b,a] = butter(2,[8 20]/(Fs/2)); %8-20Hz带通滤波
x = filter(b,a,sig);
x1 = diff(x); %差分运算
RIndex = RPeekDetect( x, Ts ); 
figure;plot(x);xlabel('点数');ylabel('幅值(mV)');
hold on;
plot(RIndex,x(RIndex),'*r');
xlim([1500 5000]);
hrate = length(x(RIndex))*Fs*60/L; %计算心率
