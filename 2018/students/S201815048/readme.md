# 智能医学仪器设计
   S201815048刘世杰
## 1.使用matlab处理基线漂移的心电信号：
要求根据提供心电数据，去除数据中的基线漂移
------
### 1.1

clc       %清空历史窗口中的内容<br>
clear all     %清空当前工作空间中的全部变量<br>
close all     %关闭所有窗口<br>
 

 fid = fopen('1520309088000.dat','rb');  %打开二进制文件<br>
 ecg_test = fread(fid,inf,'short');%读取fid<br>
 fclose(fid);<br>
 fmaxd=0.5;%截止频率为0.5Hz<br>
 fs=250;%采样率250<br>
 fmaxn=fmaxd/(fs/2);<br>
 [b,a]=butter(1,fmaxn,'low');%<br>
 sig_del=filter(b,a,ecg_test);%通过0.5Hz低通滤波器<br>
 ecg_result=ecg_test-sig_del;%得到去基线漂移的信号<br>
 %绘图<br>
 subplot(2,1,1),plot(ecg_test(1000:4000),'b');title('原始信号');ylabel('幅值');xlabel('f/hz')<br>
 subplot(2,1,2),plot(ecg_result(1000:4000),'b');title('去除基线漂移的信号');ylabel('幅值');xlabel('f/hz')<br>
 ###
 
 原始信号和处理基线漂移之后的信号：<br>
 ![image](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815048/signal%20figure/signal%20compare.jpg)

 ## 2.标记心电数据中的R波：
 ### 2.1函数规范
  代码简洁有利于提高工作效率，需要将matlab中代码所需用到的自定义功能存储为函数。<br>
 ### 2.2 
