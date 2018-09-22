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

[Fx1,fbin1]=ecg_psd(sig,fs,10,100);
[Fx2,fbin2]=ecg_psd(sig1,fs,10,100);
figure(2);plot(fbin1,Fx1,'r');hold on;plot(fbin2,Fx2,'b');
legend('原始信号功率谱','滤波后的功率谱');xlabel('f(Hz)');ylabel('psd(db)');

