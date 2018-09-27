[Fx1,fbin1]=ecg_psd(sig,fs,10,100); %psd of sig
%figure(1);plot(fbin1,Fx1,'r')
[Fx2,fbin2]=ecg_psd(sig1,fs,10,100); %psd of sig1
figure(2);plot(fbin1,Fx1,'r');hold on;plot(fbin2,Fx2,'b');
legend('原始信号功率谱','滤波后的功率谱');xlabel('f(Hz)');ylabel('psd(db)');