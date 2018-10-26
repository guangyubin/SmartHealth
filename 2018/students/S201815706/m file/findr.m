 clc;
 clear;
 fid = fopen('100.dat','rb'); %打开文件
 sig = fread(fid,inf,'short'); 
 fclose(fid);  
 L=length(sig);  
 fs=250;  
 t=1/fs:1/fs:(L-1)/fs;
 time = (0:L-1)/fs;
 [b,a]= butter(2,[8 20]/(fs/2));
 sig1=filter(b,a,sig); 
 sig1=diff(sig1); 
 sig2=abs(sig1);  
 sig3=filter(ones(1,5)/5,1,sig2);
%---------------painting---------------%
 figure(3);
 subplot(411);plot(time,sig);xlim([200 210]);title('原始信号');xlabel('T(s)');ylabel('A(mv)');
 subplot(412);plot(t,sig1);xlim([200 210]);title('滤波后信号');xlabel('T(s)');ylabel('A(mv)');
 subplot(413);plot(t,sig2);xlim([200 210]);title('对滤波后信号取绝对值');xlabel('T(s)');ylabel('A(mv)');
 subplot(414);plot(t,sig3);xlim([200 210]);title('对滤波后信号的绝对值滤波');xlabel('T(s)');ylabel('A(mv)');
 
 thr = [];
for ii = 1:10
    x = sig1(((ii-1)*fs+1): (ii*fs));
    thr(ii) =  max(x);
end
thr0 = min(thr)*0.9;
flag = 0 ;
ii = 1;
m = 1;
qrs = [];

while (ii < length(sig1))
    switch(flag)
        case 0
            if sig1(ii) > thr0   %寻找大于阈值的点
                if sig1(ii) <= sig1(ii-1)
                    flag = 1;
                    qrs(m) = ii-1;
                    m = m+1;
                end
            end
            %break;          
        case 1
            if sig1(ii) < thr0;  % 寻找小于阈值的点
                flag = 0;                
            end
            %break;
    end
    ii = ii + 1;
end
figure(4);plot(sig1);xlim([1000 5000]);hold on,plot(qrs,sig1(qrs),'*r');