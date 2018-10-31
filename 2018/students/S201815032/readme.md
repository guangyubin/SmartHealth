# 基于MATLAB的心电数据处理

## 1：心电信号的特点

人体心电信号是非常微弱的生理低频电信号，通常最大的幅值不超5mV，信号频率在0.01～35Hz之间。心电信号具有微弱、低频、高阻抗等特性，极容易受到干扰，所以分析干扰的来源，针对不同干扰采取相应的滤除措施，是数据采集重点考虑的一个问题。

## 2：滤波器的选择

根据心电信号（ecg)功率谱图可知，信号频率在0.01～35Hz之间，另外，正常人的心率是60-100次/min，两次心拍的最短时间为1s,所以选择的截止频率不大于1Hz,本实验选择的截止频率为0.5Hz,得到滤波前后的信号频谱图。
···
  clc;
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
···
![ecg_raw&hp](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_raw%26hp.jpg)
![ecg_psd](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_psd.jpg)


在ecg_hp.m文件中将滤波前后的信号及其功率谱图画出来，计算功率谱时调用函数来自ecg_psd.m文件。

## 3：对R,S波计数，计算心率

用matlab自带的findpeaks函数，该函数是寻找极大值，同时可以限定条件，比如峰值阈值，极大值间隔等等。峰值阈值的设定是根据滤波后的ecg信号图设定的，也可以设为峰值的70%；极大值间隔是用最短间隔时间0.5S*fs得到。通过对峰值标记（检测R波）后计数，除以有效数据的时间长度，即为心率。结果显示该ecg的心率在75-76次/min。（qrs_detect.m）

![ecg_abs](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_abs.jpg)
![ecg_detect_RS](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_detect_RS.jpg)

## 4：差分阈值法检测R波

幅值的最小阈值设定方法是去掉最大值和最小值之后去平均值，相邻R-R波之间的时间最小阈值是通过获得前6个R峰，计算个数与长度的比。前6个R峰的获得是在点数范围内，当后一个点幅值的绝对值大于前一个幅值点的幅值时，标定。(peek_R.m+RPeekDetect.m)

![Peek_R](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/Peek_R.jpg)
