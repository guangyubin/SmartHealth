%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%ѡ��ǰ10s�����ֵ�����Ƴ���ʼ��ֵ
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
            if sig1(ii) > thr0   %Ѱ�Ҵ�����ֵ�ĵ�
                if sig1(ii) <= sig1(ii-1)
                    flag = 1;
                    qrs(m) = ii-1;
                    m = m+1;
                end
            end
            %break;          
        case 1
            if sig1(ii) < thr0;  % Ѱ��С����ֵ�ĵ�
                flag = 0;                
            end
            %break;
    end
    ii = ii + 1;
end
end