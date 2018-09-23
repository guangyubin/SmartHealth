#基于MATLAB的心电数据处理
*1：心电信号的特点

人体心电信号是非常微弱的生理低频电信号，通常最大的幅值不超5mV，信号频率在0.01～35Hz之间。心电信号具有微弱、低频、高阻抗等特性，极容易受到干扰，所以分析干扰的来源，针对不同干扰采取相应的滤除措施，是数据采集重点考虑的一个问题。
*2：滤波器的选择

根据心电信号（ecg)功率谱图可知，信号频率在0.01～35Hz之间，另外，正常人的心率是60-100次/min，两次心拍的最短时间为1s,所以选择的截止频率不大于1Hz,本实验选择的截止频率为0.5Hz,得到滤波前后的信号频谱图。
![ecg_raw&hp](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_raw%26hp.jpg)
![ecg_psd](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_psd.jpg)
在ecg_hp.m文件中将滤波前后的信号及其功率谱图画出来，计算功率谱时调用函数来自ecg_psd.m文件。
*3：对R,S波计数，计算心率

用matlab自带的findpeaks函数，该函数是寻找极大值，同时可以限定条件，比如峰值阈值，极大值间隔等等。峰值阈值的设定是根据滤波后的ecg信号图设定的，也可以设为峰值的70%；极大值间隔是用最短间隔时间0.5S*fs得到。通过对峰值标记（检测R波）后计数，除以有效数据的时间长度，即为心率。
![ecg_abs](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_abs.jpg)
![ecg_detect_RS](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815032/MATLAB%20Figure/ecg_detect_RS.jpg)
