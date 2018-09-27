clc;
clear;

fid = fopen('1520309088000.dat','rb'); %�������ļ� (rb+ ��д��һ���������ļ���ֻ�����д���� )
sig = fread(fid,inf,'short');  %��ȡ�ļ� ��inf: ����fidָ��Ĵ򿪵��ļ���ȫ�����ݣ� ��short:����16λ��������
fclose(fid);  %�ر��ļ�
L=length(sig);  %�ĵ��źŵ��ܳ�
t=1:L;
fs=250;    %����Ƶ�� 250
fmaxd=0.5;   %��ֹƵ�� 0.5   
  fmaxn = fmaxd/(fs/2);
  [b,a]= butter(1,fmaxn,'low');  % ��ư�����˹һ�׵�ͨ�˲��� ��fmaxn�ǽ�ֹƵ�ʣ�fmaxn = fmaxd*2/fs��
sig1=filter(b,a,sig);   %ͨ��0.5Hz��ͨ�˲������ź�
sig1=sig-sig1;  %ȥ����һ���źţ��õ�ȥ����Ư�Ƶ��ź�
t=1/fs:1/fs:L/fs;

%��ͼ
subplot(2,1,1);plot(t,sig,'k');%(subplot�ǽ����ͼ����һ��ƽ���ϵĹ��ߡ����У�m��ʾ��ͼ�ų�m�У�n��ʾͼ�ų�n�� ,p��ʾλ��)
                             %(plot(x,y) ��x Ԫ��Ϊ������ֵ��y Ԫ��Ϊ������ֵ�������ߡ�)
xlabel('Time(s)');ylabel('ECG(mv)');xlim([200 210]);title('ԭʼ�ź�');
subplot(2,1,2);plot(t,sig1,'k');
xlabel('Time(s)');ylabel('ECG1(mv)');xlim([200 210]);title('������˹��ͨ�˲�����ź�');