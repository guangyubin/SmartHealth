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
