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
 sig2=abs(sig1);  %ȡ����ֵ
 sig3=filter(ones(1,5)/5,1,sig2);
%---------------painting---------------%
 figure(1);
 subplot(411);plot(t,sig(1:450199));xlim([200 210]);title('ԭʼ�ź�');xlabel('Time(s)');ylabel('ECG(mv)');
 subplot(412);plot(t,sig1);xlim([200 210]);title('�˲����ź�');xlabel('Time(s)');ylabel('ECG(mv)');
 subplot(413);plot(t,sig2);xlim([200 210]);title('���˲����ź�ȡ����ֵ');xlabel('Time(s)');ylabel('ECG(mv)');
 subplot(414);plot(t,sig3);xlim([200 210]);title('���˲����źŵľ���ֵ�˲�');xlabel('Time(s)');ylabel('ECG(mv)');
%---------------Mark the R and S waves---------------%
 [maxv_sig,maxl_sig]=findpeaks(sig1,'minpeakdistance',125); %maxv���ֵ��,maxl���ֵ���Ӧ��λ��,��С���=0.5s*250 ?
 [maxv_sig,maxl_sig]=findpeaks(sig1,'minpeakheight',8);%�趨��ֵ����С�߶�
 sig4=-sig1;
 [minv_sig,minl_sig]=findpeaks(sig4,'minpeakdistance',125); 
 [minv_sig,minl_sig]=findpeaks(sig4,'minpeakheight',8);%�趨��ֵ����С�߶�
 maxl_sig=maxl_sig/fs;minl_sig=minl_sig/fs;
  figure(2);hold on;
 plot(t,sig1); %����ԭ����
 plot(maxl_sig,maxv_sig,'*','color','R');%�������ֵ��
 hold on;
 plot(minl_sig,-minv_sig,'*','color','G'); %������Сֵ��
 xlim([200 220]);xlabel('Time(s)');ylabel('ECG(mv)');title('��R��S����Ǻ��ź�');
 legend('ECG��','R��','S��');
 %---------------caculate Heart rate---------------%
 hrate1=length(maxv_sig)*fs*60/L;  %��R�����м����õ������ʣ���λ����/min��
 hrate2=length(minv_sig)*fs*60/L;  %��S�����м����õ������ʣ���λ����/min��
