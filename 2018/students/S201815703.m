%%获取心电信号数据 存储在d中
fid = fopen('1520309088000.dat','rb');%打开心电信号文件
d = fread(fid,inf,'short');%读取心电信号数据
fclose(fid);%关闭

fs=1000;T=1/fs;
N=length(d);
L=1024;
t=(0:N-1)/fs;
n=0:L-1;
f=(n/L-1/2)*fs;
X=fft(d,L);
%X=fftshift(fft(d,L));

%设计IIR滤波器并对相关指标进行分析
wp=160*2/fs;
ws=180*2/fs;
Rp=3;
Rs=15;
[N,wc]=buttord(wp,ws,Rp,Rs);
[b,a]=butter(N,wc);
H=freqz(b,a,f*2*pi/fs);
mag=abs(H);
mag_dB=20*log10((mag+eps)/max(mag));
pha=angle(H);


% 对带躁信号进行滤波并作频谱分析
x1=filter(b,a,d);
X1=fft(x1,L);
%X1=fftshift(fft(x1,L));

%绘制图像
figure(1)
subplot(2,2,1);plot(t,d);title('原始心电图时域波形');%xlabel('t/s');yablel('xt');grid;
subplot(2,2,2);plot(f,abs(X)*2/N);title('原始心电图幅度谱');%xlabel('f/Hz');yablel('幅度');grid;
subplot(2,2,3);plot(t,x1);title('滤波后心电图时域波形');%xlabel('t/s');yablel('xt');grid;
subplot(2,2,4);plot(f,abs(X1)*2/N);title('滤波后心电图幅度谱');%xlabel('f/Hz');yablel('幅度');grid;

figure(2)
subplot(3,1,1);plot(f,mag);title('滤波器幅度谱');%xlabel('f/Hz');ylabel('幅度');grid;
subplot(3,1,2);plot(f,mag_dB);title('滤波器幅度谱(dB)');%xlabel('f/Hz');ylabel('幅度');grid;
subplot(3,1,3);plot(f,pha);title('滤波器相位谱');%xlabel('f/Hz');ylabel('相位');grid;
