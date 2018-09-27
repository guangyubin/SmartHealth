# 智能医学仪器学习笔记
     李仁鑫S201815706
---
## 一.心电信号的滤波器设计
### 1.滤波器
#### （1）.目标
运用滤波器对原始心电信号进行初步处理，滤掉杂波，使心电信号更容易辨认。

### 2.代码
```
 fid = fopen('1520309088000.dat','r');
 d = fread(fid,Inf,'short');
 fclose(fid);
 fmaxd = 0.5;%截止频率为0.5Hz
 fs = 250;%采样率250
 fmaxn = fmaxd/(fs/2);
 [b,a] = butter(1,fmaxn,'low');
 [e,f] = butter(1,20/(250/2),'low');
 f1 = filter(b,a,d);%通过低通滤波器的信号
 f2 = d-f1;%获得去基线漂移的信号
 subplot(211),plot(d(1000:4000),'b');
 title('初始信号');
 subplot(212),plot(f2(1000:4000),'b');
 title('滤波后信号');
 %%
 
 for ii=1:100
     x=d(ii*2500:ii*2500+2499);
     x=x-mean(x);
     Fx(ii,:)=abs(fft(x));
 end
 %%
 fbin=0:1/10:fs-1/(10);
 figure;plot(fbin,mean(Fx,1))
```
### 2.图像
#### （1）.
![通过0.5HZ低通滤波器的信号](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815706/image/untitled1.jpg)
#### （2）.
![频域响应](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815706/image/untitled2.jpg)
