function [ Fx,fbin ] = ecg_psd(sig,fs,lwnd,loop )
%Decription: Caculate the power spectrum of ecg signal
%Input:
%   sig: ecg signal,1*N
%   fs:  sample rate
%   lwnd: length of window in sec
%   loop: max loop
%Out:
%   Fx
%   fbin
%Author:    zhihaozhao
%History:   Create in 2018.09.22
%   此处显示详细说明
% 
for li = 1:loop
    x = sig((li-1)*lwnd*fs+1:li*lwnd*fs);
    x = x - mean(x);
    Fx(li,:) = abs(fft(x));

end
Fx = mean(Fx,1);
fbin = 0:1/lwnd:fs-1/lwnd;

