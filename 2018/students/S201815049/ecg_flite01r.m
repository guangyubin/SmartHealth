clc;
clear;

fid = fopen('../../ss mat/data/1520309088000.dat','rb'); %�������ļ� 
sig = fread(fid,inf,'short');  %��ȡ�ļ� 
fclose(fid);  %�ر��ļ�
L=length(sig);  %�ĵ��źŵ��ܳ�
t=1:L;
fs=250;    %����Ƶ�� 250
fmaxd=0.5;   %��ֹƵ�� 0.5   
  fmaxn = fmaxd/(fs/2);
  [b,a]= butter(1,fmaxn,'low');  % ��ư�����˹һ�׵�ͨ�˲��� 
sig1=filter(b,a,sig);   %ͨ��0.5Hz��ͨ�˲������ź�
sig1=sig-sig1;  %ȥ����һ���źţ��õ�ȥ����Ư�Ƶ��ź�
t=1/fs:1/fs:L/fs;

%��ͼ
subplot(211);plot(t,sig,'k');
xlabel('Time(s)');ylabel('ECG(mv)');xlim([200 210]);title('ԭʼ�ź�');
subplot(212);plot(t,sig1,'k');
xlabel('Time(s)');ylabel('ECG1(mv)');xlim([200 210]);title('������˹��ͨ�˲�����ź�');