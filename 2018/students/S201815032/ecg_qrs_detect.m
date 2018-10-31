clc;
clear;
fid = fopen('100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);
fs = 250;  %������250hz
% N = length(sig);
% time = (0:N-1)/fs;
% N = length(sig);
% t=1/fs:1/fs:(N-1)/fs;
[b,a] = butter(2,[8 20]/(fs/2)); %��ͨ�˲�������ֹƵ��8hz~20hz
y1 = filter(b,a,sig);
y1 = diff(y1); %�������
y2 = abs(y1);  %ȡ����ֵ
y3 = filter(ones(1,5)/5,1,y2);  %ƽ���˲�
% % tshow =100 *fs:120*fs;%��ʾ100s��120s����
% %%��ͼ
% figure(1);subplot(411);plot(time,sig);title('ԭʼ�ź�');xlim([100 110]);xlabel('time(s)');ylabel('��ֵ');
% subplot(412);plot(t,y1);title('����������ź�');xlim([100 110]);xlabel('time(s)');ylabel('��ֵ');
% subplot(413);plot(t,y2);title('ȡ����ֵ����ź�');xlim([100 110]);xlabel('time(s)');ylabel('��ֵ');
% subplot(414);plot(t,y3);title('ƽ������ź�');xlim([100 110]);xlabel('time(s)');ylabel('��ֵ');
% 
for ii = 1:10        %ȡ10������
    x = y1(((ii-1)*fs+1):(ii*fs));   %�Բ���Ϊ1ͳ���ź�y1�����ֵ
    thr(ii) = max(x);   %�ҳ�ǰ10�������еļ���ֵ
   
end
thr0 = min(thr)*0.9;   %ȡǰʮ�������и�����ֵ����Сֵ  

flag = 0 ;
ii = 1;  %ii��ʼΪ1,���������
m = 1;   
qrs = [];
	
while (ii < length(y1)) %�ж�ii�����Ƿ���ԭ�źŴ�����
    switch(flag)
        case 0
            if y1(ii) > thr0  %�ж�ii��ʱy1��ֵ�Ƿ�>thr0
                if y1(ii) <= y1(ii-1)  
                    flag = 1;
                    qrs(m) = ii-1; %��¼��ֵ��
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
N = length(y1);  %�����źų���
% time = (0:N-1)/fs;
% t = qrs/fs;
%------------------��ͼ--------------------%
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('��ֵ');
hold on;
plot(qrs,y1(qrs),'*r');
%------------------���ʼ���--------------------%
hrate = length(y1(qrs))*fs*60/N