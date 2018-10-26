 fid = fopen('1520309088000.dat','r');
 d = fread(fid,Inf,'short');
 fclose(fid);
 fmaxd = 0.5;%��ֹƵ��Ϊ0.5Hz
 fs = 250;%������250
 fmaxn = fmaxd/(fs/2);
 [b,a] = butter(1,fmaxn,'low');
 [e,f] = butter(1,20/(250/2),'low');
 f1 = filter(b,a,d);%ͨ��5Hz��ͨ�˲������ź�
 f2 = d-f1;%���ȥ����Ư�Ƶ��ź�
 subplot(211),plot(d(1000:4000),'b');
 title('��ʼ�ź�');
 subplot(212),plot(f2(1000:4000),'b');
 title('�˲����ź�');
 %%
 
 for ii=1:100
     x=d(ii*2500:ii*2500+2499);
     x=x-mean(x);
     Fx(ii,:)=abs(fft(x));
 end
 %%
 fbin=0:1/10:fs-1/(10);
 figure;plot(fbin,mean(Fx,1))
 