%caculate the power spectrum of ecg signal
%input;
%      sig;ecg signal,1*N
%fs:   sample rate;
%ownd: length of window in sec
%loop:  max loop.
function [Fx,fbin] = Ecg_psd(ddd,fs,lwnd,loop)

for ii = 1:loop
    
    x = ddd((ii-1)*lwnd*fs+1:ii*lwnd*fs);
    x = x - mean(x);
    Fx(ii,:) = abs(fft(x));
end
Fx = mean(Fx,1);
fbin = 0:1/lwnd:fs-1/lwnd;