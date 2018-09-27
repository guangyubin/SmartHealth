%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%选择前10s的最大值，估计出初始阈值
function sig1=QRSfunction(sig1)
 thr = [];
 fs=250;
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
end