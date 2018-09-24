智能医学仪器设计
==
#基于MATLAB的心电数据处理
* 1滤除心电信号的基线漂移

fid = fopen('../../mat1/data/1520309088000.dat','rb'); %打开路径
sig = fread(fid,inf,'short');  %读取文件
fclose(fid);  %关闭文件
fs=250;    %采样率250hz
fmaxd=0.5;   %截止频率选择0.5hz  
fmaxn = fmaxd/(fs/2);
[b,a]= butter(1,fmaxn,'low');  % 设计一个一阶巴特沃斯低通滤波器
sig1=filter(b,a,sig);   %通过0.5hz低通滤波器
sig1=sig-sig1;  %去除这一段信号，得到去基漂信号
%---------------绘图---------------%

figure(1);subplot(211);plot(sig(1000:4000));xlabel('f(hz)');ylabel('幅值');title('原始信号');
subplot(212);plot(sig1(1000:4000));xlabel('f(hz)');ylabel('幅值');title('巴特沃斯低通滤波后的信号');
