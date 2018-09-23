 fid = fopen('1520309088000.dat','rb');
 d = fread(fid,inf,'short');
 fclose(fid);
 
 
 
 fmaxd=5;%截止频率为5Hz
 fs = 250;%采样率250
 fmaxn = fmaxd/(fs/2);
 [b,a] = butter(1,fmaxn,'low');
 dd = filtfilt(b,a,d);%通过5Hz提通滤波器信号
 
 cc = d-dd;
 
 subplot(2,1,1) , plot(d(1000:4000),'b');
 subplot(2,1,2) , plot(cc(1000:4000),'b');
 for li = 1:100
       x = d(li*2500:li*2500+2499);
       x = x - mean(x);
       Fx(li,:) = abs(fft(x));
 end
 fbin = 0:1/10:fs-1/10;
 figure;plot(fbin,mean(Fx,1));
 
 for li = 1:100
       x1 = cc(li*2500:li*2500+2499);
       x1 = x1 - mean(x1);
       Fx1(li,:) = abs(fft(x1));
 end
 figure;  plot(fbin,mean(Fx,1))
         hold on, plot(fbin,mean(Fx1,1),'red');