 fid = fopen('1520309088000.dat','r');
 d = fread(fid,Inf,'short');
 fclose(fid);
 %plot(d(1000:4000));
 fmaxd = 5;%截止频率为5Hz
 fs = 250;%采样率250
 fmaxn = fmaxd/(fs/2);
 f1=medfilt2(d,3);
 subplot(211),plot(d(1000:4000),'b');
 title('初始信号');
 subplot(212),plot(f1(1000:4000),'b');
 title('滤波后信号');