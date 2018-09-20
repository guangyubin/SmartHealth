clc;
clear;

fid = fopen('1520309088000.dat','rb'); %open file
sig = fread(fid,inf,'short');  %read file
fclose(fid);  %close file
l=length(sig);  %total length of ECG
t=1:l;
fs=250;    %sample rate 250
fmaxd=5;   %cut-off frequency 5   
  fmaxn = fmaxd/(fs/2);
  [b,a]= butter(1,fmaxn,'low');  % designs a Butterworth digital filter,1st order,lowpass
sig1=filter(b,a,sig);   %ECG signal after filtering
sig1=sig-sig1;  %baseline
%---------------painting---------------%
t=1/250:1/250:l/250;
figure(1);subplot(211);plot(t,sig);xlabel('Time(s)');ylabel('ECG(mv)');xlim([200 210]);title('原始信号');
subplot(212);plot(t,sig1);xlabel('Time(s)');ylabel('ECG1(mv)');xlim([200 210]);title('巴特沃斯低通滤波后的信号');
% 
% sig1=mapminmax(sig1);
% sig1 = sig1 - mean(sig1);
% Fx = abs(fft(sig1));  
% figure;plot(Fx);xlabel('f(Hz)');ylabel('幅值');title('信号频谱');
