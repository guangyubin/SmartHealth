

fid = fopen('../../data/1520309088000.dat','rb');
d = fread(fid,inf,'short');
fclose(fid);
% subplot(211);plot(d);
% subplot(211);plot(d(1000:4000));
fmaxd=5;%��ֹƵ��Ϊ5Hz
fs=250;%������250
fmaxn=fmaxd/(fs/2);
[b,a]=butter(1,fmaxn,'low');
dd=filtfilt(b,a,d);%ͨ��5Hz��ͨ�˲������ź�
cc=d-dd;          %ȥ����һ���źţ��õ�ȥ����Ư�Ƶ��ź�
%��ͼ
subplot(2,1,1),plot(d(1000:4000),'b');
subplot(2,1,2),plot(cc(1000:4000),'b');
