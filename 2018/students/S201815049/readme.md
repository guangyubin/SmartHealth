基于MATLAB的心电数据处理  
=
   1.心电信号滤波  
     本实验使用数据“1520309088000.dat”  
   1.1本实验选择的截止频率为0.5Hz，设计巴特沃斯滤波器，得到滤波前后的信号频谱图。 
   
![01ecg_sign](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815049/figure/01ecg_sign.png)           
   
   1.2在ecg_psd.m文件中将滤波前后的信号及其功率谱图画出来，计算功率谱时调用函数来自ecg_function_psd.m文件。    
  
![02ecg_psd](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815049/figure/02ecg_psd.png)  
   
   2、心电信号R波检测          
      本实验使用数据"100.dat"                
   2.1数据预处理：            
      ①8-20Hz带通滤波器②abs取绝对值③滑动平均   
      
![03ecg_R_detect](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815049/figure/03ecg_R_detect.png)    

   2.2 R点标记     
   
   ![04ecg_R_detect](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815049/figure/04ecg_R_detect.png)   
   
