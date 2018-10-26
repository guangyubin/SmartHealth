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

```
#### (3).图像

![通过0.5HZ低通滤波器的信号](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815706/image/untitled1.jpg)


### 2.绘出信号滤波前后的功率谱

写一个函数ecg_psd,输入为时域信号，采样频率，加窗长度，循环次数,输出为对数功率FX和频率范围fbin,直接调用psd函数进行绘制.

#### （1）代码
```
 fid = fopen('1520309088000.dat','r');
 d = fread(fid,Inf,'short');
 fclose(fid);
 fmaxd = 5;%截止频率为5Hz
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
	
#### （2）.图像

![频域响应](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815706/image/untitled2.jpg)
  
### 3.标记R波
#### （1）分别画出带通，差分，取绝对值，平滑滤波之后的图像
```
 clc;
 clear;
 fid = fopen('100.dat','rb');%打开文件
 sig = fread(fid,inf,'short');  %读取文件
 fclose(fid);  
 L=length(sig);  
 fs=250;  
 t=1/fs:1/fs:(L-1)/fs;
 time = (0:L-1)/fs;
 [b,a]= butter(2,[8 20]/(fs/2));
 sig1=filter(b,a,sig);
 sig1=diff(sig1); 
 sig2=abs(sig1); 
 sig3=filter(ones(1,5)/5,1,sig2);
%---------------painting---------------%
 figure(3);
 subplot(411);plot(time,sig);xlim([200 210]);title('原始信号');xlabel('T(s)');ylabel('A(mv)');
 subplot(412);plot(t,sig1);xlim([200 210]);title('滤波后信号');xlabel('T(s)');ylabel('A(mv)');
 subplot(413);plot(t,sig2);xlim([200 210]);title('对滤波后信号取绝对值');xlabel('T(s)');ylabel('A(mv)');
 subplot(414);plot(t,sig3);xlim([200 210]);title('对滤波后信号的绝对值滤波');xlabel('T(s)');ylabel('A(mv)');
```
##### 1）、图像




#### （2）找出R波个数
   通过设定阈值，记录R波个数。
   
   ``` 
thr = [];
for ii = 1:10
    x = sig1(((ii-1)*fs+1): (ii*fs));
    thr(ii) =  max(x);
end
thr0 = min(thr)*0.9;
flag = 0 ;
ii = 1;
m = 1;
qrs = [];

while (ii < length(sig1))
    switch(flag)
        case 0
            if sig1(ii) > thr0   %寻找大于阈值的点
                if sig1(ii) <= sig1(ii-1)
                    flag = 1;
                    qrs(m) = ii-1;
                    m = m+1;
                end
            end
            %break;          
        case 1
            if sig1(ii) < thr0;  % 寻找小于阈值的点
                flag = 0;                
            end
            %break;
    end
    ii = ii + 1;
end
figure(4);plot(sig1);xlim([1000 5000]);hold on,plot(qrs,sig1(qrs),'*r');
```
##### 2）、图像
   
   
   
   
## 二、运用C语言实现对心电信号的处理   

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
