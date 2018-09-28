# 智能医学仪器设计
   S201815048刘世杰
## 1.使用matlab处理基线漂移的心电信号：
要求根据提供心电数据，去除数据中的基线漂移
------
### 1.1

clc       %清空历史窗口中的内容<br>
clear all     %清空当前工作空间中的全部变量<br>
close all     %关闭所有窗口<br>
 

 fid = fopen('1520309088000.dat','rb');  %打开二进制文件<br>
 ecg_test = fread(fid,inf,'short');%读取fid<br>
 fclose(fid);<br>
 fmaxd=0.5;%截止频率为0.5Hz<br>
 fs=250;%采样率250<br>
 fmaxn=fmaxd/(fs/2);<br>
 [b,a]=butter(1,fmaxn,'low');%<br>
 sig_del=filter(b,a,ecg_test);%通过0.5Hz低通滤波器<br>
 ecg_result=ecg_test-sig_del;%得到去基线漂移的信号<br>
 %绘图<br>
 subplot(2,1,1),plot(ecg_test(1000:4000),'b');title('原始信号');ylabel('幅值');xlabel('f/hz')<br>
 subplot(2,1,2),plot(ecg_result(1000:4000),'b');title('去除基线漂移的信号');ylabel('幅值');xlabel('f/hz')<br>
 ###
 
 原始信号和处理基线漂移之后的信号：<br>
 ![image](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815048/signal%20figure/signal%20compare.jpg)

 ## 2.标记心电数据中的R波：
 ### 2.1函数规范
  代码简洁有利于提高工作效率，需要将matlab中代码所需用到的自定义功能存储为函数。<br>
  函数里注明对函数的描述，输入，输出，作者以及修改历史
 ### 2.1.1绘制功率谱
 %%function [Fx,fbin] = ecg_psd(sig,fs,lwnd,loop)<br>
 %%for ii =1:loop<br>
   %%x = sig((ii-1) * lwnd * fs+1:ii * lwnd* fs);<br>
   %%x = x - mean(x);<br>
   %%Fx(ii,:) = abs(fff(x));<br>
 %%end<br>
 %%Fx = mean(Fx,1);<br>
 %%fbin = 0:1/lwnd:fs-1/lwnd;<br>
 clc;<br>
clear;<br>
fid = fopen('../../1520309088000.dat','rb');<br>
sig_test = fread(fid,inf,'short');<br>
fclose(fid);<br>
fmaxd=5;%截止频率为5Hz<br>
fs=250;%采样率250<br>
fmaxn=fmaxd/(fs/2);<be>
[b,a]=butter(1,fmaxn,'low');<br>
sig_del=filtfilt(b,a,sig_test);%通过5Hz低通滤波器的信号<br>
ecg_result=ecg_test-sig_del; %去除这一段信号，得到去基线漂移的信号<br>
 [Fx1,fbin1] = ecg_psd(sig,fs,10,100);<br>
[Fx2,fbin2] = ecg_psd(sig2,fs,10,100);<br>
%%画图<br>
figure;<br>
plot(fbin1,Fx1);<br>
hold on;<br>
xlabel('f(Hz)');<br>
ylabel('db/Hz');<br>
plot(fbin2,Fx2);<br>
figure;plot(fbin1,Fx1) ;xlabel('f(Hz)');ylabel('dB/Hz');hold on;plot(fbin2,Fx2);<br>
![image](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815048/signal%20figure/power%20spectrum.jpg)
  
## 3.标记R波
### 3.1
fid = fopen('../../mat1/data/1520309088000.dat','rb');<br>
sig_test = fread(fid,inf,'short');<br>
fclose(fid);<br>

fs = 250; %采样率250hz<br>
[b,a] = butter(2,[8 20]/(fs/2)); %信号通过8~20hz的带通滤波器<br>

y1 = filter(b,a,sig_test);<br>
y1 = diff(y1); %通过一个差分放大器<br>
y2 = abs(y1); %取绝对值<br>
y3 = filter(ones(1,5),1,y2); %平滑滤波<br>
tshow = 100fs:120fs;%显示100s到120s数据<br>

figure(1);subplot(411);plot(sig(tshow));;title('滤波后信号');xlabel('f(Hz)');ylabel('幅值');<br>
subplot(412);plot(y1(tshow));title('通过差分放大器后的信号');xlabel('f(Hz)');ylabel('幅值');<br>
subplot(413);plot(y2(tshow));title('取绝对值后的信号');xlabel('f(Hz)');ylabel('幅值');<br>
subplot(414);plot(y3(tshow));title('平滑滤波处理的信号');xlabel('f(Hz)');ylabel('幅值');<br>
![image](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815048/signal%20figure/four%20figure%20of%20the%20test.jpg)
