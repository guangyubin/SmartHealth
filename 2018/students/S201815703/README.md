# 智能医学仪器作业
     赵志浩S201815703
---
## 一.心电信号的滤波器设计
### 1.使用巴特沃斯滤波器对心电信号进行处理
#### （1）.目标
运用滤波器对原始心电信号进行初步处理，滤掉杂波，使心电信号更容易辨认。

#### (2).代码
```
 fid = fopen('1520309088000.dat','r');%打开文件
 sig = fread(fid,inf,'short');%读取心电信号数据
 fclose(fid);%关闭流
 fmaxd = 0.5;%截止频率为0.5Hz
 fs = 250;%采样率250
 fmaxn = fmaxd/(fs/2);
 [b,a] = butter(1,fmaxn,'low');
 [e,f] = butter(1,20/(250/2),'low');
 f1 = filter(b,a,sig);%通过低通滤波器的信号
 f2 = sig-f1;%获得去基线漂移的信号
 subplot(211),plot(sig(1000:4000),'b');
 title('初始信号');
 subplot(212),plot(f2(1000:4000),'b');
 title('滤波后信号');

```
#### (3).图像

![通过0.5HZ低通滤波器的信号](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815703/1.jpg)


### 2.绘出信号滤波前后的功率谱

写一个函数ecg_psd,输入为时域信号，采样频率，加窗长度，循环次数,输出为对数功率FX和频率范围fbin,直接调用psd函数进行绘制.

#### （1）代码
```
 fid = fopen('1520309088000.dat','r');%打开文件
 sig = fread(fid,inf,'short');%读取心电信号数据
 fclose(fid);%关闭流
 fmaxd = 0.5;%截止频率为0.5Hz
 fs = 250;%采样率250
 fmaxn = fmaxd/(fs/2);
 [b,a] = butter(1,fmaxn,'low');
 [e,f] = butter(1,20/(250/2),'low');
 f1 = filter(b,a,sig);%通过低通滤波器的信号
 f2 = sig-f1;%获得去基线漂移的信号
 subplot(211),plot(sig(1000:4000),'b');
 title('初始信号');
 subplot(212),plot(f2(1000:4000),'b');
 title('滤波后信号');
 %%
 [Fx,fbin] = ecg_psd(f1,250,10,100);% ecg_psd 函数代码见ecg_psd.m文件
 [Fx1,fbin] = ecg_psd(f2,250,10,100);
 
 figure;  
 plot(fbin,mean(Fx,1))
 hold on, plot(fbin,mean(Fx1,1),'red');
 ```
	
#### （2）.图像

![滤波与原始信号频域分析对比图](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815703/滤波与原始信号频域分析对比图.png)
  
### 3.标记R波
#### （1）分别画出带通，差分，取绝对值，平滑滤波之后的图像
```
 clc;
 clear;
 fid = fopen('100.dat','rb');%打开文件
 sig = fread(fid,inf,'short');  %读取文件
 fclose(fid);  
 L=length(sig);  
 fs=250;  %采样率为250HZ
 t=1/fs:1/fs:(L-1)/fs;
 time = (0:L-1)/fs;
 [b,a]= butter(2,[8 20]/(fs/2));%通过巴特沃斯滤波器
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

![](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815703/image/3.jpg)


#### （2）找出R波个数
   通过设定阈值，记录R波个数，并标记，用于计算心率。
   
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
   
![](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815703/image/4.jpg)   
   
   
## 二、运用C语言实现对心电信号的处理   
   运用C语编写滤波器，对心电信号进行滤波。

### 1、主函数

```
main.cpp
#include <stdio.h>
#include "QrsDetect.h"
void main()
{
     printf("hello world!\n");
	FILE *fp =  fopen("C:\\Users\\Administrator.HYB-20180130BKM\\Desktop\\智能医学作业\\data\\100.dat", "rb");
	FILE *fp1 = fopen("C:\\Users\\Administrator.HYB-20180130BKM\\Desktop\\智能医学作业\\data\\100_filt.dat", "wb");
	FILE *fp2 = fopen("C:\\Users\\Administrator.HYB-20180130BKM\\Desktop\\智能医学作业\\data\\100.txt", "w+");
	short x;
	int pos = 0;
	int i; 
	/*for ( i = 0; i < 20000; i++)
	{
		fread(&x, sizeof(short), 1, fp);
	    //printf("there is a qrs in samples  %d \n", x);
		short y = smooth(diff(bpfilter(x)));
		fwrite(&y, sizeof(short), 1, fp1);
		//printf("%d",x);
		int res = QrsDectet(x);
		if (res == 1)
		{
			fprintf(fp2,"%d \n" ,i );
			printf("there is a qrs in samples  %d \n", i);
		}
	}*/
	
	int total = 0;

	while (fread(&x, sizeof(short), 1, fp))
	{
		short y = smooth(diff(bpfilter(x)));
		fwrite(&y, sizeof(short), 1, fp1);
		//	printf("%d",x);
		int res = QrsDectet(x);
		if (res == 1)   
		{
			
		     total = total ++;
			fprintf(fp2,"%d \n" ,i );
			printf("there is a qrs in samples  %d \n", i);
		}
	}
	printf("the total beats is   %d \n", total);	
	fclose(fp);
	fclose(fp1);
	fclose(fp2);
} 
```
### 2、滤波器以及找出心电信号的QRS波个数
```
QrsDectet.cpp
#include "QrsDectect.h"

float bpfilter(float xn)
{
	static const int OrderA = 5;
	static const int OrderB = 5;
	static const float Ceof_A[OrderA] = { 1, -3.39756791945667, 4.49126771653074, -2.73830049324164, 0.652837763407545 };
	static const float Ceof_B[OrderB] = { 0.0186503962278372, 0, -0.0373007924556744, 0, 0.0186503962278372 };
	static float buffer_x[OrderA] = { 0 }; //使一维数组内的五个都是零；
	static float buffer_y[OrderB] = { 0 };
	static int filter_index = 0;

	float tmpx = Ceof_B[0] * xn;;
	int ptr = filter_index;
	for (int i = 1; i < OrderB; i++)
	{
		tmpx += buffer_x[ptr] * Ceof_B[i];
		ptr--;
		if (ptr < 0)  ptr = OrderB - 1;
	}

	float tmpy = 0;
	ptr = filter_index;
	for (int j = 0; j < OrderA; j++)
	{
		tmpy += buffer_y[ptr] * Ceof_A[j ];
	}
	float yn = tmpx - tmpy ;	
	filter_index++;
	if (filter_index == 5) filter_index = 0;
	buffer_y[filter_index] = yn;
	buffer_x[filter_index] = xn;
	return yn;

}

//*依据差分方程写滤波器；
float diff(float xn)
{
	static float xn1 = 0;
	float yn = xn -xn1;  
	xn1 = xn;
	yn = fabs(yn);//直接利用绝对值函数求差分；
	return yn;
}
// y(n) = y(n-1) + x(n) - x(n-N)
float smooth(float xn)
{
	static const int NSmooth = 25;
	static float buffer_x[NSmooth] = { 0 };
	static float yn1 = 0;
	static int ptrBuff = 0;

	yn1 +=  xn - buffer_x[ptr];

	ptrBuff++;
	if (ptrBuff == NSmooth)  ptrBuff = 0;
	buffer_x[ptrBuff] = xn;

	return yn1/ NSmooth;

}

int median(int *array, int datnum)
{
	int i, j, k, temp, sort[20];
	for (i = 0; i < datnum; ++i)
		sort[i] = array[i];
	for (i = 0; i < datnum; ++i)
	{
		temp = sort[i];
		for (j = 0; (temp < sort[j]) && (j < i); ++j);
		for (k = i - 1; k >= j; --k)
			sort[k + 1] = sort[k];
		sort[j] = temp;
	}
	return(sort[datnum >> 1]);
}
int QrsDectet(int x)
{
		static int count = 0;
	static int sampleRate = 250;
	static int det_thresh = 0;

	static int initMax = 0, nInitPeaks = 0;
	static int peaksbuf[8];

	static int flag = 0; 
	static int delay = 0;

	int datum = smooth(diff(bpfilter(x)));
	count++;

	int isQrs = 0;
	if (nInitPeaks  < 8)
	{
		if (datum > initMax) initMax = datum;
		if (count%sampleRate == 0)
		{
			peaksbuf[nInitPeaks] = initMax;
			initMax = 0; 
			flag = 0; 
			nInitPeaks++;
			if (nInitPeaks == 8)
			{
				det_thresh = median(peaksbuf, 8)*0.5;
			}
		}
	}
	else
	{
	
		switch (flag)
		{
		case 0:
			if(datum > det_thresh)
				flag = 1;
			break;
		case 1:
			delay++;
			if (delay == 10)
			{
				flag = 2;
			}
			break;
		case 2:

			if(datum < det_thresh)
			{
				isQrs = 1;
				flag = 3;
			}
			break;
		case 3:
			delay++;
			if (delay < 250*0.3)
			{
				flag = 0; 
				delay = 0;
			}
			break;
		}	
	}

	return isQrs;
}

#endif
```

### 3、.H文件

```
QrsDetect.h
#ifndef __QRS_DETECT_H__
#define __QRS_DETECT_H__

float qrsfilter(float x);

float bpfilter(float x);
float diff(float x);
float smooth(float x);;

int QRSDetect(float x);


#endif

```
### 4、matlab处理代码：
```
fid = fopen('100.dat', 'rb');
d = fread(fid, inf, 'short');
fclose(fid);
fid = fopen('C:\Users\Administrator.HYB-20180130BKM\Desktop\智能医学作业\data\100_filt.dat', 'rb');
d2 = fread(fid, inf, 'short');
fclose(fid);
figure;
subplot(211); plot(d2);
qrs = load('C:\Users\Administrator.HYB-20180130BKM\Desktop\智能医学作业\data\100.txt');
subplot(212); plot(d2); hold on; plot(qrs, d2(qrs), '.r');
```

#### 5.图像

![图像](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815703/image/)
