%%%标注R T（三）
 clc;
 clear;
 fid = fopen('100.dat','rb'); %open file
 sig = fread(fid,inf,'short');  %read file
 fclose(fid);  %close file
 L=length(sig);  %total length of ECG
 fs=250;  %sample rate 250
 t=1/fs:1/fs:(L-1)/fs;
 time = (0:L-1)/fs;
 [b,a]= butter(2,[8 20]/(fs/2));
 sig1=filter(b,a,sig); %estimated baseline
 sig1=diff(sig1); 
 sig2=abs(sig1);  %取绝对值
 sig3=filter(ones(1,5)/5,1,sig2);
 
%---------------painting---------------%
 figure(3);
 subplot(411);plot(time,sig);xlim([200 210]);title('原始信号');xlabel('Time(s)');ylabel('ECG(mv)');
 subplot(412);plot(t,sig1);xlim([200 210]);title('滤波后信号');xlabel('Time(s)');ylabel('ECG(mv)');
 subplot(413);plot(t,sig2);xlim([200 210]);title('对滤波后信号取绝对值');xlabel('Time(s)');ylabel('ECG(mv)');
 subplot(414);plot(t,sig3);xlim([200 210]);title('对滤波后信号的绝对值滤波');xlabel('Time(s)');ylabel('ECG(mv)');

sig1=QRSfunction(sig1);
figure;plot(sig1);xlim([1000 5000]);hold on,plot(qrs,sig1(qrs),'*r');
rate=length(thr)*60/L;
legend(rate);