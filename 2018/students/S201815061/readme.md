
基于MATLAB的心电信号处理
### 1、滤除心电信号的基线漂移
    对1520309088000.dat文件中的心电信号的数据进行处理，滤除心电信号中的基线漂移
 close all
 fid = fopen('1520309088000.dat','r');  %打开文件
 sig = fread(fid,Inf,'short');  %读取信号
 fclose(fid);   %关闭文件
 %plot(d(1000:4000));
 fmaxd = 0.5;   %截止频率为5Hz
 fs = 250;  %采样率250
 fmaxn = fmaxd/(fs/2);
 [b,a] = butter(2,fmaxn,'low'); %设计一个二阶的巴特沃斯低通滤波器
 sig1 = filter(b,a,sig);    %通过0.5Hz低通滤波器的信号
 sig1 = sig-sig1;   %获得去基线漂移的信号
 %% 画图
 figure(1);
 subplot(211);
 plot(sig(1000:4000),'b');
 xlabel('f(hz)');
 ylabel('幅值');
 title('原始信号');
 subplot(212);
 plot(sig1(1000:4000),'b');
 xlabel('f(hz)');
 ylabel('幅值');
 title('滤除基线漂移后的信号');
![ecg_est](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815061/figure/ecg_est.jpg)
### 2、分析心电信号的功率谱
clear all
fid = fopen('1520309088000.dat','rb');
sig = fread(fid,Inf,'short');
fclose(fid);
fs = 250;   %采样率为250  
fmaxd = 0.5;    %截止频率为0.5HZ
fmaxn = fmaxd/(fs/2);
[b,a] = butter(2,fmaxn,'low');
sig1 = filter(b,a,sig); %通过0.5HZ低通滤波器的信号
sig2 =sig-sig1;  %获得去基线漂移的信号
[Fx1,fbin1] = ecg_psd(sig,fs,10,100);
[Fx2,fbin2] = ecg_psd(sig2,fs,10,100);
%%画图
figure;
plot(fbin1,Fx1);
hold on;
xlabel('f(Hz)');
ylabel('db/Hz');
plot(fbin2,Fx2);
![ecg_power](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815061/figure/ecg_power.jpg)
### 3、对QRS波进行检测
clear all
fid = fopen('1520309088000.dat','rb');
ecg = fread(fid,Inf,'short');
fclose(fid);
fs = 250;   %采样频率为250HZ
[b,a] = butter(2,[8 20]/(fs/2));    %设计一个二阶的巴特沃斯带通滤波器，截止频率为8-20HZ
y1 = filter(b,a,ecg);
y1 = diff(y1);  %差分运算
y2 = abs(y1);   %取绝对值
y3 = filter(ones(1,5),1,y2);    %进行平滑滤波
tshow = 100*fs : 120*fs;    %显示100s-120s的心电数据
%%画图
figure(1);
subplot(411);plot(ecg(tshow));title('滤波后的信号');xlabel('f(Hz)');ylabel('幅值');
subplot(412);plot(y1(tshow));title('差分运算后的信号');xlabel('f(Hz)');ylabel('幅值');
subplot(413);plot(y2(tshow));title('取绝对值后的信号');xlabel('f(Hz)');ylabel('幅值');
subplot(414);plot(y3(tshow));title('平滑后的信号');xlabel('f(Hz)');ylabel('幅值');
%%对R波进行标记
Threshold = max(y3(tshow))*0.6;  %阈值选择，取峰值0.6
%% ecg_max:峰值点；ecg_location:峰值点位置；MinPeakDistance:最小间距;MinPeakHeight:峰值最小高度
[ecg_max,ecg_location] = findpeaks(y3(tshow),'MinPeakDistance',100,'MinPeakHeight',Threshold);
%%画图
figure(2);
plot(y3(tshow));
title('第100s到120s的心电信号');
xlabel('f(Hz)');
ylabel('幅值');
hold on;
plot(ecg_location,ecg_max,'*','color','r');
legend('心电信号','R波标记');
![ecg_qrsdet](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815061/figure/ecg_qrsdet.jpg)
![ecg_qrsdet2](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815061/figure/ecg_qrsdet2.jpg)
### 4、对100.dat文件进行处理，计算心跳次数
      对100.dat文件进行处理后，得出的心跳次数为：74.3934次/分钟。
clear all
fid = fopen('100.dat','rb');
ecg = fread(fid,Inf,'short');
fclose(fid);
fs = 250;   % 采样率2520Hz
L = length(ecg);
time = (0:L-1)/fs;
[b,a] = butter(2,[8,20]/(fs/2));    %带通滤波器，截止频率8hz-20hz
y1 = filter(b,a,ecg);
y1 = diff(y1);  %差分运算
y2 = abs(y1);   %取绝对值
y3 = filter(ones(1,5)/5,1,y2);  %平滑滤波
for ii = 1:10   %取10秒数据
    x = y1(((ii-1)*fs+1) : (ii*fs));
    thr(ii) = max(x);   %找出这10秒数据中的最大值
end
thr0 = min(thr)*0.9;    %取前10秒的数据中的极大值
flag = 0;
ii = 1;     %令ii初始值为1，代表抽样点
m = 1;
qrs = [];
while(ii < length(y1))  %判断ii点时y1幅值是否大于thr0
    switch(flag)
        case 0
            if y1(ii) > thr0
                if y1(ii) <= y1(ii-1)
                    flag = 1;
                    qrs(m) = ii-1;
                    m = m+1;
                end
            end
        case 1
            if y1(ii) < thr0
                flag = 0;
            end
    end
    ii = ii+1;
end
figure;
plot(y1);
xlim([1000 5000]);
hold on;
plot(qrs,y1(qrs),'*r');
%%  计算心率
calculate_rate = length(y1(qrs))*fs*60/L
![ecg_100](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815061/figure/ecg_100.jpg)

   
