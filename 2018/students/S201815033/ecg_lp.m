fid = fopen('../../mat1/data/1520309088000.dat','rb'); %��·��
sig = fread(fid,inf,'short'); %��ȡ�ļ�
fclose(fid); %�ر��ļ�
fs = 250; %������250hz
fmaxd = 0.5; %��ֹƵ��ѡ��0.5hz
fmaxn = fmaxd/(fs/2);
[b,a]= butter(1,fmaxn,'low'); % ���һ��һ�װ�����˹��ͨ�˲���
sig1 = filter(b,a,sig); %ͨ��0.5hz��ͨ�˲���
sig1 = sig-sig1; %ȥ����һ���źţ��õ�ȥ��Ư�ź�

%-----------��ͼ---------------%

figure(1);subplot(211);plot(sig(1000:4000));xlabel('f(hz)');ylabel('��ֵ');title('ԭʼ�ź�');
subplot(212);plot(sig1(1000:4000));xlabel('f(hz)');ylabel('��ֵ');title('ȥ������Ư�ƺ���ź�');