clc;
clear;
fid = fopen('../../mat1/data/1520309088000.dat','rb');
sig = fread(fid,inf,'short');
 fclose(fid);
%  fmaxd=5;%��ֹƵ��Ϊ5Hz
%  fs=250;%������250
%  [b,a] = butter(3,[8 20]/(fs/2));
%  y1 = filter(b,a,d);
%  y1=diff(y1);
%  y2=abs(y1);
%  y3=filter(ones(1,5),1,y2);
%  tshow=100*fs:120*fs;
%  figure;subplot(411);plot(d(tshow));
%  subplot(412);plot(y1(tshow));
%  subplot(413);plot(y2(tshow));
%  subplot(414);plot(y3(tshow));
%  fmaxn=fmaxd/(fs/2);
%  [b,a]=butter(1,fmaxn,'low');
%  [e,f]=butter(1,20/(250/2),'low');
%  dd=filter(b,a,d);%ͨ��5Hz��ͨ�˲������ź�
%  cc=d-dd;%ȥ����һ���źţ��õ�ȥ����Ư�Ƶ��ź�
%  ddd=filter(e,f,cc);%ȥ��������ĸ�Ƶ�źţ�ʹ����ƽ��
% subplot(2,1,1),plot(d(1000:4000),'b');xlabel('ԭʼ�ź�')
%  subplot(2,1,2),plot(ddd(1000:4000),'b');xlabel('ȥ������Ư�Ƶ��ź�')
fmaxd=5;%��ֹƵ��Ϊ5Hz
fs=250;%������250
fmaxn=fmaxd/(fs/2);
[b,a]=butter(1,fmaxn,'low');
sig1=filtfilt(b,a,sig);%ͨ��5Hz��ͨ�˲������ź�
sig2=sig-sig1;          %ȥ����һ���źţ��õ�ȥ����Ư�Ƶ��ź�

%%
[Fx1,fbin1] =  Ecg_psd(sig,fs,10,100);
[Fx2,fbin2] =  Ecg_psd(sig2,fs,10,100);

figure;plot(fbin1,Fx1) ;xlabel('f(Hz)');ylabel('dB/Hz');hold on;plot(fbin2,Fx2);
%%

