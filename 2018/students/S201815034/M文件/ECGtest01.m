clc;
clear;

fid = fopen('1520309088000.dat','rb'); %打开数据文件 (rb+ 读写打开一个二进制文件，只允许读写数据 )
sig = fread(fid,inf,'short');  %读取文件 （inf: 读出fid指向的打开的文件的全部数据） （short:精度16位整型数）
fclose(fid);  %关闭文件
L=length(sig);  %心电信号的总长
t=1:L;
fs=250;    %采样频率 250
fmaxd=0.5;   %截止频率 0.5   
  fmaxn = fmaxd/(fs/2);
  [b,a]= butter(1,fmaxn,'low');  % 设计巴特沃斯一阶低通滤波器 （fmaxn是截止频率，fmaxn = fmaxd*2/fs）
sig1=filter(b,a,sig);   %通过0.5Hz低通滤波器的信号
sig1=sig-sig1;  %去除这一段信号，得到去基线漂移的信号
t=1/fs:1/fs:L/fs;

%绘图
subplot(2,1,1);plot(t,sig,'k');%(subplot是将多个图画到一个平面上的工具。其中，m表示是图排成m行，n表示图排成n列 ,p表示位置)
                             %(plot(x,y) 以x 元素为横坐标值，y 元素为纵坐标值绘制曲线。)
xlabel('Time(s)');ylabel('ECG(mv)');xlim([200 210]);title('原始信号');
subplot(2,1,2);plot(t,sig1,'k');
xlabel('Time(s)');ylabel('ECG1(mv)');xlim([200 210]);title('巴特沃斯低通滤波后的信号');