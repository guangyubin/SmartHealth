基于MATLAB的心电信号预处理
====
主要工作为对原始心电信号进行预处理，将信号中包含的一些干扰滤除或抑制掉，绘制滤波前后的信号功率谱图，在绘出的信号函数图像上标注出QRS波<br>
1.心电信号的滤波及去除基线漂移
_______
考虑到正常人的心跳都在30次/分-200次/分的范围内，频率范围在0.5hz-3.3hz,故设计滤波器的截止频率不应过高  <br>
使用数据1520309088000.dat，设计巴特沃斯滤波器实现,设置截止频率为0.5HZ，得到各波段清晰的波形<br>
![心电信号滤波去漂移.png](http://github.com/guangyubin/SmartHealth/2018/students/S201815034/images/心电信号滤波去漂移.png)

2.绘出信号滤波前后的功率谱
_______
写一个函数ecg_psd<br>
输入为时域信号，采样频率，加窗长度，循环次数<br>
输出为对数功率FX和频率范围fbin<br>
直接调用psd函数进行绘制<br>
![滤波前后的信号功率谱.png](http://github.com/guangyubin/SmartHealth/2018/students/S201815034/images/滤波前后的信号功率谱.png)

3.对信号进行滤波，取绝对值，标记R波
________
设计巴特沃斯2阶带通滤波器，通带频率8-20HZ,之后再对信号做平滑，取绝对值<br>
![信号带通滤波取绝对值.png](http://github.com/guangyubin/SmartHealth/2018/students/S201815034/images/信号带通滤波取绝对值.png)

4.在信号图像上标记出R波
________
找出前10S内心电信号的最大值thr[ii],把阈值设为最大值的90%，用循环遍历信号找出范围内大于阈值的点，绘图<br>
![标记出R波.png](http://github.com/guangyubin/SmartHealth/2018/students/S201815034/images/标记出R波.png)
<br>
<br>

1.创建的函数QRSfunction.m调用错误,还需调试<br>
2.使用legend函数计算心率未实现，正调试
