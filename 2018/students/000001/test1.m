

fid = fopen('../../data/234.dat','rb');
ecg = fread(fid,inf,'short');
fclose(fid);

ecg_qrsdetect;
%%
[Fx1 , fbin1] =  ecg_psd( sig,fs , 10 , 100);
[Fx2 , fbin2] =  ecg_psd( dd,fs , 10 , 100);
figure;plot(fbin1,Fx1) ;hold on;plot(fbin2,Fx2);

%%
fbin = 0 :1/10:fs-1/(10);
figure;plot(fbin,mean(Fx,1));
