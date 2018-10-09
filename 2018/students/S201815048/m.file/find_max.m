clc;clear;
fid = fopen('F:/作业/data/100.dat','rb');
sig = fread(fid,inf,'short');
fclose(fid);

fs = 250; %采样率250hz
N = length(sig);
time = (0:N-1)/fs;
N = length(sig);
t=1/fs:1/fs:(N-1)/fs;%从1/fs开始，步长为1/fs，终值为(N-1)/fs
[b,a] = butter(2,[8 20]/(fs/2)); %带通滤波器，截止频率8hz~20hz
y1 = filter(b,a,sig);%经过带通滤波器
y1 = diff(y1); %差分运算
y2 = abs(y1); %取绝对值
y3 = filter(ones(1,5)/5,1,y2); %平滑滤波
for ii = 1:10 %取10秒数据
x = y1(((ii-1)*fs+1):(ii*fs)); %以步长为1统计信号y1各点的值：取值为1到fs
thr(ii) = max(x); %找出前10秒数据中的极大值

end
thr0 = min(thr)*0.9; %取前十秒数据中各极大值的最小值 

flag = 0 ;
ii = 1; %ii初始为1,代表抽样点
m = 1; 
qrs = [];

while (ii < length(y1)) %判断ii长度是否在原信号带宽内
switch(flag)
case 0
if y1(ii) > thr0 %判断ii点时y1幅值是否>thr0
if y1(ii) <= y1(ii-1) %?
flag = 1;
qrs(m) = ii-1; %记录峰值点
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
N = length(y1); %计算信号长度
% time = (0:N-1)/fs;
% t = qrs/fs;
%------------------绘图--------------------%
figure;plot(y1);xlim([1000 5000]);xlabel('f(hz)');ylabel('幅值');
hold on;
plot(qrs,y1(qrs),'*r');
%------------------心率计算--------------------%
hrate = length(y1(qrs))*fs*60/N;