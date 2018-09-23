<p>代码如下</p><br>
<p>&nbsp;&nbsp;fid = fopen('1520309088000.dat','rb');%打开流<br></p>
<p>&nbsp;&nbsp;sig = fread(fid,inf,'short');%读取心电信号数据<br></p>
<p>&nbsp;&nbsp;fclose(fid);%关闭流<br></p>
<br>
<p>&nbsp;&nbsp;fmaxd = 5;%截止频率为5Hz<br></p>
