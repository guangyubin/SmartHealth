clc;clear;
fid = fopen('F:/��ҵ/data/100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);

fs = 250; %������250hz
N = length(sig);
time = (0:N-1)/fs;
N = length(sig);
t=1/fs:1/fs:(N-1)/fs;%��1/fs��ʼ������Ϊ1/fs����ֵΪ(N-1)/fs
[b,a] = butter(2,[8 20]/(fs/2)); %��ͨ�˲�������ֹƵ��8hz~20hz
y1 = filter(b,a,sig);%������ͨ�˲���
y1 = diff(y1); %�������
y2 = abs(y1); %ȡ����ֵ
y3 = filter(ones(1,5)/5,1,y2); %ƽ���˲�
for ii = 1:10 %ȡ10������
x = y1(((ii-1)*fs+1):(ii*fs)); %�Բ���Ϊ1ͳ���ź�y1�����ֵ��ȡֵΪ1��fs
thr(ii) = max(x); %�ҳ�ǰ10�������еļ���ֵ

end
thr0 = min(thr)*0.9; %ȡǰʮ�������и�����ֵ����Сֵ 

flag = 0 ;
ii = 1; %ii��ʼΪ1,���������
m = 1; 
qrs = [];

while (ii < length(y1)) %�ж�ii�����Ƿ���ԭ�źŴ�����
switch(flag)
case 0
if y1(ii) > thr0 %�ж�ii��ʱy1��ֵ�Ƿ�>thr0
if y1(ii) <= y1(ii-1) %?
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
N = length(y1); %�����źų���
% time = (0:N-1)/fs;
% t = qrs/fs;
%------------------��ͼ--------------------%
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('��ֵ');
hold on;
plot(qrs,y1(qrs),'*r');
%------------------���ʼ���--------------------%
hrate = length(y1(qrs))*fs*60/N;