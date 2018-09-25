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
