clc;
clear;
fid = fopen('100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);
fs = 250;  %采样率250hz
[b,a] = butter(2,[8 20]/(fs/2)); %8-20Hz带通滤波
y1 = filter(b,a,sig);
y1 = diff(y1); %差分运算
y2 = abs(y1);  %取绝对值
y3 = filter(ones(1,5)/5,1,y2);  %平滑滤波

for ii = 1:10        %取10秒数据
    x = y1(((ii-1)*fs+1):(ii*fs));   
    thr(ii) = max(x);   
   
end
a=0.05*(sum(y1)-max(y1)-min(y1));
thr0 = min(thr)*a;   %阈值  

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
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('幅值(mV)');
hold on;
plot(qrs,y1(qrs),'*r');
%------------------心率计算--------------------%
hrate = length(y1(qrs))*fs*60/N;
