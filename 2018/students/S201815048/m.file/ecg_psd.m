function [Fx,fbin] = ecg_psd(sig,fs,lwnd,loop)
for ii =1:loop
   x = sig((ii-1) * lwnd * fs+1:ii * lwnd* fs);
   x = x - mean(x);
   Fx(ii,:) = abs(fff(x));
 end
 Fx = mean(Fx,1);
 fbin = 0:1/lwnd:fs-1/lwnd;