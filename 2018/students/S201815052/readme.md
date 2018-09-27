#智能医学仪器设计

##MATLAB心电数据处理

###一、心电信号基线漂移的滤除
	
	fid = fopen('../../智能医疗仪器课程/data/1520309088000.dat','rb');
	ECG_data = fread(fid,inf,'short');
	fclose(fid);
	f=1;
	fs=250; %采样率
	Wn=(2*f)/fs;
	[b,a]=butter(2,Wn,'low');   %2阶巴特沃斯低通系数
	y=filtfilt(b,a,ECG_data);   %0相移滤波
	ECG_filter1=ECG_data-y;          
	%绘图
	figure(1);subplot(211);plot(ECG_data(1000:4000));title('原始信号');
	subplot(212);plot(ECG_filter1(1000:4000));title('滤除基线漂移后的信号');
![ECG_filter1](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815052/matlab_figure/ECG_filter1.jpg)

### 二、QRS波中R点的检测
检测代码如下：

	thr = [];
	for j = 1:10
	    x = ECG_filter(((j-1)*fs+1): (j*fs));
	    thr(j) =  max(x);
	end
	thr0 = min(thr)*0.8;   %取阈值
	flag = 0 ;
	i = 1;
	m = 1;
	RR_count = 0;
	qrs = [];
	hrate = [];
	while (i < length(ECG_filter))
		switch(flag)
			case 0
				RR_count = RR_count + 1;
				if ECG_filter(i) > thr0   %寻找大于阈值的点
					if ECG_filter(i) <= ECG_filter(i-1)  % R点判断
						if m>1
							if RR_count <75
								thr0 = thr0 * 1.2;    %阈值调整
							end
							if RR_count>500
								thr0 = thr0 * 0.8;     %阈值调整
							end
						end
						RR_count = 0;
						flag = 1;
						qrs(m) = i-1;    % QRS顶点
						m = m+1;
					end          
				 end
				%break;          
			case 1
				 RR_count = RR_count + 1;
				if ECG_filter(i) < thr0;  % 寻找小于阈值的点
					flag = 0;                
				end
				%break;
		end
		if (m-1) >=4
		   count_coverage = (qrs(m-1)-qrs(m-4))/3 ;   %3个RR间期求平均
		   hrate(m-1) = 60 *250/count_coverage;     %心率计算
		end
		i = i + 1;
	end

检测结果如下图：

![QRS](https://github.com/guangyubin/SmartHealth/blob/master/2018/students/S201815052/matlab_figure/QRS.jpg)

