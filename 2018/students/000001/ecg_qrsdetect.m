% function qrs = ecg_qrsdetect(ecg , fig)
fig = 1;

fs = 250;
[b,a]=butter(2,[8 20]/(fs/2));

y1 = filter(b,a,ecg);
y1 = diff(y1);
y2 = abs(y1);
y3 = filter(ones(1,5),1,y2);

for ii = 1:10
    x = y3(((ii-1)*fs+1):(ii*fs));
    thr(ii) = max(x);
end
thr0 = median(thr)*0.4;

flag = 0 ;
ii = 1;
m = 1;
rpos = [];

while (ii < length(y3))
    switch(flag)
        case 0
            if y3(ii) > thr0
                flag = 1;
                rpos(m) = ii-1;
                ii = floor(ii +0.05*fs);
                m = m+1;               
            end
          
        case 1
            if y3(ii) < thr0
                flag = 0;
                ii = ii + 0.2*fs;
            end        
       
    end
    ii = ii+1;
end
%%
figure;subplot(211);ecg_plot(y3/200,fs,rpos,rpos,floor(rpos(300)/fs),120);
subplot(212);ecg_plot(ecg/200,fs,rpos,rpos,floor(rpos(300)/fs),120);
% ref_pos = readannot('../../data/234.atr');

figure;plot(diff(rpos));

%%

