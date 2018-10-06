clear all;
fid=fopen('100.dat','rb');
x=fread(fid,inf,'short');
fclose(fid);
figure(1);
x1=x(1:5000);
subplot(512);
plot(x1,'k');
xlabel('取前五千点信号')
subplot(511);
plot(x,'k');
xlabel('原始信号')
x2=detrend(x1);
subplot(513);plot(x2)
xlabel('去除基线漂移后的信号')
fs=250;    %采样频率 250
fmaxd=30;   %截止频率30
  fmaxn = fmaxd/(fs/2);
  [b,a]= butter(1,fmaxn,'low');
x3=filter(b,a,x2);
subplot(514);plot(x3);xlabel('滤波后的信号')
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
