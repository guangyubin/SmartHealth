智能医学仪器设计
==
                     张奇宇S201815033
----    
# 基于MATLAB的心电数据处理
## 一.滤除心电信号的基线漂移

fid = fopen('../../mat1/data/1520309088000.dat','rb');                  %打开路径<br>
sig = fread(fid,inf,'short');  %读取文件<br>
fclose(fid);      %关闭文件<br>
fs = 250;    %采样率250hz<br>
fmaxd = 0.5;   %截止频率选择0.5hz<br> 
fmaxn = fmaxd/(fs/2);<br>
[b,a]= butter(1,fmaxn,'low');  % 设计一个一阶巴特沃斯低通滤波器<br>
sig1 = filter(b,a,sig);   %通过0.5hz低通滤波器<br>
sig1 = sig-sig1;  %去除这一段信号，得到去基漂信号<br>

%-----------绘图---------------%<br>

figure(1);subplot(211);plot(sig(1000:4000));xlabel('f(hz)');ylabel('幅值');title('原始信号');<br>
subplot(212);plot(sig1(1000:4000));xlabel('f(hz)');ylabel('幅值');title('去除基线漂移后的信号');<br>

![ecg lp](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815033/matlab%20figure/ecg_l.jpg) 

## 二.心电信号功率谱

clc;<br>
clear;<br>
fid = fopen('../../mat1/data/1520309088000.dat','rb');<br>
sig = fread(fid,inf,'short');<br>
fclose(fid);<br>
fmaxd=5;%截止频率为5Hz<br>
fs=250;%采样率250<br>
fmaxn=fmaxd/(fs/2);<br>
[b,a]=butter(1,fmaxn,'low');<br>
sig1=filtfilt(b,a,sig);%通过5Hz低通滤波器的信号<br>
sig2=d-dd;          %去除这一段信号，得到去基线漂移的信号<br>

[Fx1,fbin1] =  Ecg_psd(sig,fs,10,100);<br>
[Fx2,fbin2] =  Ecg_psd(sig2,fs,10,100);<br>
%-----------绘图----------%<br>
figure;plot(fbin1,Fx1) ;xlabel('f(Hz)');ylabel('dB/Hz');hold on;plot(fbin2,Fx2);<br>
![ecg_p](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815033/matlab%20figure/ecg_p.jpg)

## 三.对心电信号R波进行标记
* （1） 1520309088000.dat数据进行处理

fid = fopen('../../mat1/data/1520309088000.dat','rb');<br>
sig = fread(fid,inf,'short');<br>
fclose(fid);<br>

fs = 250;  %采样率250hz<br>
[b,a] = butter(2,[8 20]/(fs/2)); %带通滤波器，截止频率8hz~20hz<br>

y1 = filter(b,a,sig);<br>
y1 = diff(y1); %差分运算<br>
y2 = abs(y1);  %取绝对值<br>
y3 = filter(ones(1,5),1,y2);  %平滑滤波<br>
tshow = 100*fs:120*fs;%显示100s到120s数据<br>
%---------------------绘图------------------------%<br>
figure(1);subplot(411);plot(sig(tshow));;title('滤波后信号');xlabel('f(Hz)');ylabel('幅值');<br>
subplot(412);plot(y1(tshow));title('差分运算后的信号');xlabel('f(Hz)');ylabel('幅值');<br>
subplot(413);plot(y2(tshow));title('取绝对值后的信号');xlabel('f(Hz)');ylabel('幅值');<br>
subplot(414);plot(y3(tshow));title('平滑后的信号');xlabel('f(Hz)');ylabel('幅值');<br>


% ---------------------标记R波---------------------%<br>
 Threshold = max(y3(tshow))*0.6;%阈值选择，取峰值*0.6<br>
%%S_pks:峰值点；S_locs:峰值点位置；MinPeakDistance：最小间距；MinPeakHeight：峰值最小高度<br>
[S_pks,S_locs] = findpeaks(y3(tshow),'MinPeakDistance',100,'MinPeakHeight',Threshold);<br>
%-----------------------绘图-----------------------%<br>
figure(2);plot(y3(tshow));<br>
title('第100s到120s ECG');xlabel('f(hz)');ylabel('幅值');<br>
hold on;<br>
plot(S_locs,S_pks,'*','color','r');<br>
legend('ECG波','R波标记');<br>

![ecg_r](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815033/matlab%20figure/ecg_det1.jpg)
![ecg_rb](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815033/matlab%20figure/ecg_det2.jpg)

* （2） 100.dat数据进行处理

clc;clear;<br>
fid = fopen('../../mat1/data/100.dat','rb');<br>
sig = fread(fid,inf,'short');<br>
fclose(fid);<br>

fs = 250;  %采样率250hz<br>
N = length(sig);<br>
time = (0:N-1)/fs;<br>
N = length(sig);<br>
t=1/fs:1/fs:(N-1)/fs;<br>
[b,a] = butter(2,[8 20]/(fs/2)); %带通滤波器，截止频率8hz~20hz<br>
y1 = filter(b,a,sig);<br>
y1 = diff(y1); %差分运算<br>
y2 = abs(y1);  %取绝对值<br>
y3 = filter(ones(1,5)/5,1,y2);  %平滑滤波<br>
for ii = 1:10        %取10秒数据<br>
    x = y1(((ii-1)*fs+1):(ii*fs));   %以步长为1统计信号y1各点的值<br>
    thr(ii) = max(x);   %找出前10秒数据中的极大值<br>
   
end<br>
thr0 = min(thr)*0.9;   %取前十秒数据中各极大值的最小值  <br>

flag = 0 ;<br>
ii = 1;  %ii初始为1,代表抽样点<br>
m = 1;   <br>
qrs = [];<br>
	
while (ii < length(y1)) %判断ii长度是否在原信号带宽内<br>
    switch(flag)<br>
        case 0<br>
            if y1(ii) > thr0  %判断ii点时y1幅值是否>thr0<br>
                if y1(ii) <= y1(ii-1)  <br>
                    flag = 1;<br>
                    qrs(m) = ii-1; %记录峰值点<br>
                    m = m+1;<br>
                end<br>
            end<br>
        case 1<br>
            if y1(ii) < thr0<br>
                flag = 0;<br>
            end<br>
    end<br>
    ii = ii+1;<br>
end<br>
N = length(y1);  %计算信号长度<br>
% time = (0:N-1)/fs;<br>
% t = qrs/fs;<br>
%------------------绘图--------------------%<br>
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('幅值');<br>
hold on;<br>
plot(qrs,y1(qrs),'*r');<br>
%------------------心率计算--------------------%<br>
hrate = length(y1(qrs))*fs*60/N<br>

![ecg_det_100](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815033/matlab%20figure/ecg_det_100.jpg)

