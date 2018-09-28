clc;
clear;
fid = fopen('100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);
fs = 250;  %������250hz
[b,a] = butter(2,[8 20]/(fs/2)); %8-20Hz��ͨ�˲�
y1 = filter(b,a,sig);
y1 = diff(y1); %�������
y2 = abs(y1);  %ȡ����ֵ
y3 = filter(ones(1,5)/5,1,y2);  %ƽ���˲�

for ii = 1:10        %ȡ10������
    x = y1(((ii-1)*fs+1):(ii*fs));   
    thr(ii) = max(x);   
   
end
a=0.05*(sum(y1)-max(y1)-min(y1));
thr0 = min(thr)*a;   %��ֵ  

flag = 0 ;
ii = 1;  
m = 1;   
qrs = [];
	
while (ii < length(y1))
    switch(flag)
        case 0
            if y1(ii) > thr0  
                if y1(ii) <= y1(ii-1)  
                    flag = 1;
                    qrs(m) = ii-1;
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
N = length(y1);
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('��ֵ(mV)');
hold on;
plot(qrs,y1(qrs),'*r');
%------------------���ʼ���--------------------%
hrate = length(y1(qrs))*fs*60/N;
