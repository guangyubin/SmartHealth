%����ecg_function_psd�����������˲�ǰ������

[Fx1,fbin1]=ecg_function_psd(sig,fs,10,100); %sig�Ĺ�����
[Fx2,fbin2]=ecg_function_psd(sig1,fs,10,100); % sig1�Ĺ�����
figure(2);plot(fbin1,Fx1,'r');hold on;plot(fbin2,Fx2,'b');
legend('ԭʼ�źŹ�����','�˲���Ĺ�����');xlabel('f(Hz)');ylabel('psd(db)');