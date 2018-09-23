<p>代码如下:</p><br>
<p>&nbsp;&nbsp;fid = fopen('1520309088000.dat','rb');%打开流<br></p>
<p>&nbsp;&nbsp;sig = fread(fid,inf,'short');%读取心电信号数据<br></p>
<p>&nbsp;&nbsp;fclose(fid);%关闭流<br></p>
<br>
<p>&nbsp;&nbsp;fmaxd = 5;%截止频率为5Hz<br></p>
<p>&nbsp;&nbsp;fs = 250;%采样率250<br></p>
<p>&nbsp;&nbsp;fmaxn = fmaxd/(fs/2);<br></p>
<p>&nbsp;&nbsp;[b,a] = butter(1,fmaxn,'low');%巴特沃斯一阶低通滤波器<br></p>
<p>&nbsp;&nbsp;filt_sig = filtfilt(b,a,sig);%通过5Hz提通滤波器信号<br></p>
<p>&nbsp;&nbsp;new_sig = sig-filt_sig;<br></p>
<p>&nbsp;&nbsp;%绘图<br></p>
<p>&nbsp;&nbsp;subplot(2,1,1) , plot(sig(1000:4000),'b');<br></p>
<p>&nbsp;&nbsp;subplot(2,1,1) , plot(filt_sig(1000:4000),'b');<br></p>
<p>图形如下:</p><br>
<img src="SmartHealth/2018/students/S201815703/1.jpg"/>
