clear all;clc;close all;
fid = fopen('../../mat1/data/1520309088000.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);

fs = 250;  %������250hz
[b,a] = butter(2,[8 20]/(fs/2)); %��ͨ�˲�������ֹƵ��8hz~20hz

y1 = filter(b,a,sig);
y1 = diff(y1); %�������
y2 = abs(y1);  %ȡ����ֵ
y3 = filter(ones(1,5)/5,1,y2);  %ƽ���˲�
tshow = 100*fs:120*fs;%��ʾ100s��120s����
%%��ͼ
figure(1);subplot(411);plot(sig(tshow));title('�˲����ź�');xlabel('f(Hz)');ylabel('��ֵ');
subplot(412);plot(y1(tshow));title('����������ź�');xlabel('f(Hz)');ylabel('��ֵ');
subplot(413);plot(y2(tshow));title('ȡ����ֵ����ź�');xlabel('f(Hz)');ylabel('��ֵ');
subplot(414);plot(y3(tshow));xlabel('f(Hz)');ylabel('��ֵ');


% ---------------------���R��---------------------%
 Threshold = max(y1(tshow))*0.6;%��ֵѡ��ȡ��ֵ*0.6
%%S_pks:��ֵ�㣻S_locs:��ֵ��λ�ã�MinPeakDistance����С��ࣻMinPeakHeight����ֵ��С�߶�
[S_pks,S_locs] = findpeaks(y1(tshow),'MinPeakDistance',100,'MinPeakHeight',Threshold);
%-----------------------��ͼ-----------------------%
figure(2);plot(y1(tshow));
title('��100s��120s ECG');xlim([1000 5000]);xlabel('f(hz)');ylabel('��ֵ');
hold on;
plot(S_locs,S_pks,'*r');
legend('ECG��','R�����');


