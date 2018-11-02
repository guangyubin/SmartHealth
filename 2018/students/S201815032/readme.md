# 智能医学仪器设计

## 一、基于MATLAB的心电数据处理

### 1.心电信号的特点

人体心电信号是非常微弱的生理低频电信号，通常最大的幅值不超5mV，信号频率在0.01～35Hz之间。心电信号具有微弱、低频、高阻抗等特性，极容易受到干扰，所以分析干扰的来源，针对不同干扰采取相应的滤除措施，是数据采集重点考虑的一个问题。

### 2.滤波器的选择

根据心电信号（ecg)功率谱图可知，信号频率在0.01～35Hz之间，另外，正常人的心率是60-100次/min，两次心拍的最短时间为1s,所以选择的截止频率不大于1Hz,本实验选择的截止频率为0.5Hz,得到滤波前后的信号频谱图。
```clc;
clear;
fid = fopen('1520309088000.dat','rb'); %open file
sig = fread(fid,inf,'short');  %read file
fclose(fid);  %close file
L=length(sig);  %total length of ECG
t=1:L;
fs=250;    %sample rate 250
fmaxd=0.5;   %cut-off frequency 0.5   
fmaxn = fmaxd/(fs/2);
[b,a]= butter(2,fmaxn,'low');  % designs a Butterworth digital filter,1st order,lowpass
sig1=filter(b,a,sig);   %ECG signal after filtering
sig1=sig-sig1;  %estimated baseline;
%---------------painting---------------%
t=1/fs:1/fs:L/fs;
figure(1);subplot(211);plot(t,sig);xlabel('Time(s)');ylabel('ECG(mv)');xlim([200 210]);title('原始信号');
subplot(212);plot(t,sig1);xlabel('Time(s)');ylabel('ECG1(mv)');xlim([200 210]);title('巴特沃斯低通滤波后的信号');
[Fx1,fbin1]=ecg_psd(sig,fs,10,100); %psd of sig
[Fx2,fbin2]=ecg_psd(sig1,fs,10,100); %psd of sig1
figure(2);plot(fbin1,Fx1,'r');hold on;plot(fbin2,Fx2,'b');
legend('原始信号功率谱','滤波后的功率谱');xlabel('f(Hz)');ylabel('psd(db)');
```
```
function [Fx,fbin]=ecg_psd(sig,fs,lwnd,loop)
 for ii=1:loop
  x=sig((ii-1)*lwnd*fs+1:ii*lwnd*fs);
  x=x-mean(x);
  Fx(ii,:)=abs(fft(x));
 end
Fx=mean(Fx,1);
fbin=0:1/lwnd:fs-1/lwnd;
```
<div align=center><img width="600" height="450" src="https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_raw%26hp.jpg"/></div>
<div align=center><img width="600" height="450" src="https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_psd.jpg"/></div>

在ecg_hp.m文件中将滤波前后的信号及其功率谱图画出来，计算功率谱时调用函数来自ecg_psd.m文件。

### 3.对R,S波计数，计算心率

用matlab自带的findpeaks函数，该函数是寻找极大值，同时可以限定条件，比如峰值阈值，极大值间隔等等。峰值阈值的设定是根据滤波后的ecg信号图设定的，也可以设为峰值的70%；极大值间隔是用最短间隔时间0.5S*fs得到。通过对峰值标记（检测R波）后计数，除以有效数据的时间长度，即为心率。结果显示该ecg的心率在75-76次/min。（qrs_detect.m）
```
clc;
clear;
fid = fopen('1520309088000.dat','rb'); %open file
sig = fread(fid,inf,'short');  %read file
fclose(fid);  %close file
L=length(sig);  %total length of ECG
fs=250;    %sample rate 250
t=1/fs:1/fs:(L-1)/fs;
[b,a]= butter(2,[8 20]/(fs/2));
sig1=filter(b,a,sig); %estimated baseline
sig1=diff(sig1); 
sig2=abs(sig1);  %取绝对值
sig3=filter(ones(1,5)/5,1,sig2);
%---------------painting---------------%
figure(1);
subplot(411);plot(t,sig(1:450199));xlim([200 210]);title('原始信号');xlabel('Time(s)');ylabel('ECG(mv)');
subplot(412);plot(t,sig1);xlim([200 210]);title('滤波后信号');xlabel('Time(s)');ylabel('ECG(mv)');
subplot(413);plot(t,sig2);xlim([200 210]);title('对滤波后信号取绝对值');xlabel('Time(s)');ylabel('ECG(mv)');
subplot(414);plot(t,sig3);xlim([200 210]);title('对滤波后信号的绝对值滤波');xlabel('Time(s)');ylabel('ECG(mv)');
%---------------Mark the R and S waves---------------%
[maxv_sig,maxl_sig]=findpeaks(sig1,'minpeakdistance',125); %maxv峰峰值点,maxl峰峰值点对应的位置,最小间隔=0.5s*250
[maxv_sig,maxl_sig]=findpeaks(sig1,'minpeakheight',8);%设定峰值的最小高度
sig4=-sig1;
[minv_sig,minl_sig]=findpeaks(sig4,'minpeakdistance',125); 
[minv_sig,minl_sig]=findpeaks(sig4,'minpeakheight',8);%设定峰值的最小高度
maxl_sig=maxl_sig/fs;minl_sig=minl_sig/fs;
figure(2);hold on;
plot(t,sig1); %绘制原波形
plot(maxl_sig,maxv_sig,'*','color','R');%绘制最大值点
hold on;
plot(minl_sig,-minv_sig,'*','color','G'); %绘制最小值点
xlim([200 220]);xlabel('Time(s)');ylabel('ECG(mv)');title('对R、S波标记后信号');
legend('ECG波','R波','S波');
%---------------caculate Heart rate---------------%
hrate1=length(maxv_sig)*fs*60/L;  %对R波进行计数得到的心率，单位（次/min）
hrate2=length(minv_sig)*fs*60/L;  %对S波进行计数得到的心率，单位（次/min）
```
<div align=center><img width="600" height="450" src="https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_abs.jpg"/></div>
<div align=center><img width="600" height="450" src="https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_detect_RS.jpg"/></div>

### 4.差分阈值法检测R波

幅值的最小阈值设定方法是去掉最大值和最小值之后去平均值，相邻R-R波之间的时间最小阈值是通过获得前6个R峰，计算个数与长度的比。前6个R峰的获得是在点数范围内，当后一个点幅值的绝对值大于前一个幅值点的幅值时，标定。(peek_R.m+RPeekDetect.m)
```
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
```
```
clc;
clear;
fid = fopen('100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);
fs = 250;  %采样率250hz
% N = length(sig);
% time = (0:N-1)/fs;
% N = length(sig);
% t=1/fs:1/fs:(N-1)/fs;
[b,a] = butter(2,[8 20]/(fs/2)); %带通滤波器，截止频率8hz~20hz
y1 = filter(b,a,sig);
y1 = diff(y1); %差分运算
y2 = abs(y1);  %取绝对值
y3 = filter(ones(1,5)/5,1,y2);  %平滑滤波
% % tshow =100 *fs:120*fs;%显示100s到120s数据
% %%绘图
% figure(1);subplot(411);plot(time,sig);title('原始信号');xlim([100 110]);xlabel('time(s)');ylabel('幅值');
% subplot(412);plot(t,y1);title('差分运算后的信号');xlim([100 110]);xlabel('time(s)');ylabel('幅值');
% subplot(413);plot(t,y2);title('取绝对值后的信号');xlim([100 110]);xlabel('time(s)');ylabel('幅值');
% subplot(414);plot(t,y3);title('平滑后的信号');xlim([100 110]);xlabel('time(s)');ylabel('幅值');
 for ii = 1:10        %取10秒数据
  x = y1(((ii-1)*fs+1):(ii*fs));   %以步长为1统计信号y1各点的值
  thr(ii) = max(x);   %找出前10秒数据中的极大值
 end
thr0 = min(thr)*0.9;   %取前十秒数据中各极大值的最小值  
flag = 0 ;
ii = 1;  %ii初始为1,代表抽样点
m = 1;   
qrs = [];
		
while (ii < length(y1)) %判断ii长度是否在原信号带宽内
 switch(flag)
	case 0
	   if y1(ii) > thr0  %判断ii点时y1幅值是否>thr0
	     if y1(ii) <= y1(ii-1)  
	        flag = 1;
	        qrs(m) = ii-1; %记录峰值点
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
N = length(y1);  %计算信号长度
% time = (0:N-1)/fs;
% t = qrs/fs;
%------------------绘图--------------------%
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('幅值');
hold on;
plot(qrs,y1(qrs),'*r');
%------------------心率计算--------------------%
hrate = length(y1(qrs))*fs*60/N
```
<div align=center><img width="600" height="300" src="https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/Peek_R.jpg"/></div>
<div align=center><img width="600" height="450" src="https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_qrs_detect.jpg"/></div>

## 二、基于C++的心电数据处理
### 1.主函数
```
#include<stdio.h>
#include"QrsDetect.h"


void main()
{
	printf("hello world!\n");
	FILE *fp =  fopen("C:\\Users\\HP\\Desktop\\qrsdetecg\\data\\100.dat", "rb");
	FILE *fp1 = fopen("C:\\Users\\HP\\Desktop\\qrsdetecg\\data\\100_filt.dat", "wb");
	FILE *fp2 = fopen("C:\\Users\\HP\\Desktop\\qrsdetecg\\data\\100.txt", "w+");
	short x;
	int pos = 0;
	int i; 

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

// matlab code

/*              
//fid = fopen('C:\Users\guang\Desktop\SmartHealth\2018\data\100.dat', 'rb');
//d = fread(fid, inf, 'short');
//fclose(fid);
//
//fid = fopen('C:\Users\guang\Desktop\SmartHealth\2018\data\100_filt.dat', 'rb');
//d2 = fread(fid, inf, 'short');
//fclose(fid);
//figure;
//subplot(211); plot(d2);
//
//qrs = load('C:\Users\guang\Desktop\SmartHealth\2018\data\100.txt');
//
//subplot(212); plot(d2); hold on; plot(qrs, d2(qrs), '.r');
*/
```
### 2.带通滤波器、QRS标定
```
#include "Qrsdetect.h"
#include <math.h>//引入绝对值函数；
#include <stdio.h>
//从matlab中求出a，b系数；
//int QrsDetect_flag = 0;
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
	for (int j = 1; j < OrderA; j++)
	{
		tmpy += buffer_y[ptr] * Ceof_A[j ];
		ptr--;
		if (ptr < 0)  ptr = OrderA - 1;
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

	// 

	static const int NSmooth = 25;
	static float buffer_x[NSmooth] = { 0 };
	static float yn1 = 0;
	static int ptrBuff = 0;

	int ptr = ptrBuff;
	yn1 +=  xn - buffer_x[ptr];


	buffer_x[ptrBuff] = xn;
	ptrBuff++;
	if (ptrBuff == NSmooth)  ptrBuff = 0;


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

//
//float smooth(float xn[])
//{	float yn[] = {};
//	sum =0;
//	for(int j=0;j<size;j++)
//	{
//		if(j<N/2)
//		{
//			for(int k=0;k<N;k++)
//			{
//				sum+=xn[j+k];
//			}
//			xn[j]=sum/N;//若j<N/2,则直接取前几位数的平均值；
//		}
//		else
//			if(j<size-N/2)
//			{
//				for(int k=0;k<N/2;k++)
//			{	
//				sum+=(xn[j+k]+xn[j-k]);
//			}
//			xn[j]=sum/N;//取j前后各k位数,计算size-N/2前所有数的平均值；
//			{
//			else
//			}
//				for(int k=0;k<size-j;k++)
//			{
//				sum+=xn[j-k];
//			}
//			xn[j]=sum/N;
//		}
//		yn[]=xn[j]
//		sum=0;
//	}
//	return yn[];
//}

```

### 3.h文件
```
//头文件里面是一些宏定义、全局变量定义、函数声明
#ifndef __QRS_DETECT_H__
#define __QRS_DERECT_H__
#define size  1000//数组大小为1000
#define N 10//滑动平均滤波计算平均值时所取的点数



float bpfilter(float x);
float diff(float x);
float smooth(float x);

int QrsDectet(int x);

#endif
```
