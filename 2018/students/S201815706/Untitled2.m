 fid = fopen('1520309088000.dat','r');
 d = fread(fid,Inf,'short');
 fclose(fid);
 %plot(d(1000:4000));
 fmaxd = 5;%��ֹƵ��Ϊ5Hz
 fs = 250;%������250
 fmaxn = fmaxd/(fs/2);
 f1=medfilt2(d,3);
 subplot(211),plot(d(1000:4000),'b');
 title('��ʼ�ź�');
 subplot(212),plot(f1(1000:4000),'b');
 title('�˲����ź�');