clear all;
fid=fopen('100.dat','rb');
x=fread(fid,inf,'short');
fclose(fid);
figure(1);
x1=x(1:5000);
subplot(512);
plot(x1,'k');
xlabel('ȡǰ��ǧ���ź�')
subplot(511);
plot(x,'k');
xlabel('ԭʼ�ź�')
x2=detrend(x1);
subplot(513);plot(x2)
xlabel('ȥ������Ư�ƺ���ź�')
fs=250;    %����Ƶ�� 250
fmaxd=30;   %��ֹƵ��30
  fmaxn = fmaxd/(fs/2);
  [b,a]= butter(1,fmaxn,'low');
x3=filter(b,a,x2);
subplot(514);plot(x3);xlabel('�˲�����ź�')
%T=abs(max(x3)*0.8);
sigtemp=x3;
siglen=length(x3);
sigmax=[];
T=abs(max(x3)*0.8);
for i=1:siglen-2
    if(x3(i+1)>x3(i)&x3(i+1)>x3(i+2))|(x3(i+1)<x3(i)&x3(i+1)<x3(i+2))
    sigmax=[sigmax;abs(sigtemp(i+1)),i+1];
    end
end
rvalue=[];
for i=1:siglen;
    if sigmax(i,1)>T
        rvalue=[rvalue;sigmax(i,2)];
    end
end
rvalue_1=rvalue;
subplot(515);plot(sigtemp,rvalue_1,'*','color','R')
grid on;
