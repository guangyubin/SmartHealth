fid = fopen('../../data/1520309088000.dat','rb');
ecg = fread(fid,inf,'short');
fclose(fid);

fs = 250;
[b,a]=butter(2,[8 20]/(fs/2));

y1 = filter(b,a,ecg);
y1 = diff(y1);
y2 = abs(y1);
y3 = filter(ones(1,5),1,y2);
tshow = 100*fs:120*fs;

figure;subplot(411);plot(ecg(tshow));
subplot(412);plot(y1(tshow));
subplot(413);plot(y2(tshow));
subplot(414);plot(y3(tshow));
%%
pos = [44 240 300];
x = ecg(1000:2000);
figure;plot(x);hold on; plot(pos,x(pos),'*r');
