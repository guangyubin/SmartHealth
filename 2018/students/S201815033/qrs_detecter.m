clear all;clc;close all;
fid = fopen('../../mat1/data/1520309088000.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);

fs = 250;  %采样率250hz
[b,a] = butter(2,[8 20]/(fs/2)); %带通滤波器，截止频率8hz~20hz

y1 = filter(b,a,sig);
y1 = diff(y1); %差分运算
y2 = abs(y1);  %取绝对值
y3 = filter(ones(1,5)/5,1,y2);  %平滑滤波
tshow = 100*fs:120*fs;%显示100s到120s数据
%%绘图
figure(1);subplot(411);plot(sig(tshow));title('滤波后信号');xlabel('f(Hz)');ylabel('幅值');
subplot(412);plot(y1(tshow));title('差分运算后的信号');xlabel('f(Hz)');ylabel('幅值');
subplot(413);plot(y2(tshow));title('取绝对值后的信号');xlabel('f(Hz)');ylabel('幅值');
subplot(414);plot(y3(tshow));xlabel('f(Hz)');ylabel('幅值');


% ---------------------标记R波---------------------%
 Threshold = max(y1(tshow))*0.6;%阈值选择，取峰值*0.6
%%S_pks:峰值点；S_locs:峰值点位置；MinPeakDistance：最小间距；MinPeakHeight：峰值最小高度
[S_pks,S_locs] = findpeaks(y1(tshow),'MinPeakDistance',100,'MinPeakHeight',Threshold);
%-----------------------绘图-----------------------%
figure(2);plot(y1(tshow));
title('第100s到120s ECG');xlim([1000 5000]);xlabel('f(hz)');ylabel('幅值');
hold on;
plot(S_locs,S_pks,'*r');
legend('ECG波','R波标记');


