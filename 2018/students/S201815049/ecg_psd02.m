%引用ecg_function_psd函数，画出滤波前后功率谱

[Fx1,fbin1]=ecg_function_psd(sig,fs,10,100); %sig的功率谱
[Fx2,fbin2]=ecg_function_psd(sig1,fs,10,100); % sig1的功率谱
figure(2);plot(fbin1,Fx1,'r');hold on;plot(fbin2,Fx2,'b');
legend('原始信号功率谱','滤波后的功率谱');xlabel('f(Hz)');ylabel('psd(db)');