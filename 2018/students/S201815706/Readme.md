# 智能医学仪器学习笔记
     李仁鑫S201815706
---
## 一.心电信号的滤波器设计
### 1.使用巴特沃斯滤波器对心电信号进行处理
#### （1）.目标
运用滤波器对原始心电信号进行初步处理，滤掉杂波，使心电信号更容易辨认。

#### (2).代码
```
 fid = fopen('1520309088000.dat','r');
 d = fread(fid,Inf,'short');
 fclose(fid);
 fmaxd = 0.5;%截止频率为0.5Hz
 fs = 250;%采样率250
 fmaxn = fmaxd/(fs/2);
 [b,a] = butter(1,fmaxn,'low');
 [e,f] = butter(1,20/(250/2),'low');
 f1 = filter(b,a,d);%通过低通滤波器的信号
 f2 = d-f1;%获得去基线漂移的信号
 subplot(211),plot(d(1000:4000),'b');
 title('初始信号');
 subplot(212),plot(f2(1000:4000),'b');
 title('滤波后信号');
 %%
 
 for ii=1:100
     x=d(ii*2500:ii*2500+2499);
     x=x-mean(x);
     Fx(ii,:)=abs(fft(x));
 end
 %%
 fbin=0:1/10:fs-1/(10);
 figure;plot(fbin,mean(Fx,1))
```
#### (3).图像
##### 1.
![通过0.5HZ低通滤波器的信号](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815706/image/untitled1.jpg)
##### 2.
![频域响应](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815706/image/untitled2.jpg)

### 2.绘出信号滤波前后的功率谱

写一个函数ecg_psd,输入为时域信号，采样频率，加窗长度，循环次数,输出为对数功率FX和频率范围fbin,直接调用psd函数进行绘制.

#### （1）代码
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
ylabel('psd(db)');<br>
plot(fbin2,Fx2);<br>
figure;plot(fbin1,Fx1) ;xlabel('f(Hz)');ylabel('dB/Hz');hold on;plot(fbin2,Fx2);<br>
![image](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815048/signal%20figure/power%20spectrum.jpg)
  
### 3.标记R波
#### （1）分别画出带通，差分，取绝对值，平滑滤波之后的图像
fid = fopen('../../1520309088000.dat','rb');<br>
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
clc;clear;
fid = fopen('F:/作业/data/100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);


#### （2）找出R波个数
      通过设定阈值，记录R波个数。
fs = 250; %采样率250hz<br>
N = length(sig);<br>
time = (0:N-1)/fs;<br>
N = length(sig);<br>
t=1/fs:1/fs:(N-1)/fs;%从1/fs开始，步长为1/fs，终值为(N-1)/fs<br>
[b,a] = butter(2,[8 20]/(fs/2)); %带通滤波器，截止频率8hz~20hz<br>
y1 = filter(b,a,sig);%经过带通滤波器<br>
y1 = diff(y1); %差分运算<br>
y2 = abs(y1); %取绝对值<br>
y3 = filter(ones(1,5)/5,1,y2); %平滑滤波<br>
for ii = 1:10 %取10秒数据<br>
x = y1(((ii-1)*fs+1):(ii*fs)); %以步长为1统计信号y1各点的值：取值为1到fs<br>
thr(ii) = max(x); %找出前10秒数据中的极大值<br>
end<br>

thr0 = min(thr)*0.9; %取前十秒数据中各极大值的最小值 <br>

flag = 0 ;<br>
ii = 1; %ii初始为1,代表抽样点<br>
m = 1; <br>
qrs = [];<br>

while (ii < length(y1)) %判断ii长度是否在原信号带宽内<br>
switch(flag)<br>
case 0<br>
if y1(ii) > thr0 %判断ii点时y1幅值是否>thr0<br>
if y1(ii) <= y1(ii-1) %<br>
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
N = length(y1); %计算信号长度<br>
% time = (0:N-1)/fs;<br>
% t = qrs/fs;<br>
%------------------绘图--------------------%
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('幅值');<br>
hold on;<br>
plot(qrs,y1(qrs),'*r');<br>
![image](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815048/signal%20figure/detect%20R%20wave.jpg)




```
QrsDectet.cpp
#include "QrsDectect.h"

float qrsfilter(float x)
{
	return 0;
}

float bpfilter(float x)
{

	return 0;
}
float diff(float x)
{
	return 0;
}
//online QRSdetector using t;
//intput : a sample ecg data;
//out;
//     out=0 :there is no qrs;
//     out=1: there is a qrs;

int QRSDetect(float x);


#endif



QrsDetect.h
#ifndef __QRS_DETECT_H__
#define __QRS_DETECT_H__

float qrsfilter(float x);

float bpfilter(float x);
float diff(float x);
float smooth(float x);

//online QRSdetector using t;
//intput : a sample ecg data;
//out;
//     out=0 :there is no qrs;
//     out=1: there is a qrs;

int QRSDetect(float x);


#endif


main.cpp
#include <stdio.h>
#include "QrsDetect.h"
void main()
{
      printf("helloworld\n");
      FILE*fp=fopen("data//100.dat","rb");
	  FILE*fp1=fopen("data//100_filt.dat","wb");
	  short x;
	  for(int i=0;i<1000;i++)
	  {
		  fread(&x,sizeof(short),1,fp);
		  short y=2*x;
		  fwrite(&y,sizeof(short),1,fp1);
		  printf("%d",x);
		  int res=QRSDetect(x);
		  if(res==1)
		  printf("there is a qrs in %d samples ",i);
	  }
	  fclose(fp);
	  fclose(fp1);

} 
```
