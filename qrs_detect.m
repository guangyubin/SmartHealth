clear
fid = fopen('../../����ҽ�������γ�/data/100.dat','rb');
ECG_data = fread(fid,inf,'short');
fclose(fid);

fs = 250;
[b,a] = butter(3,[8 20]/(fs/2));   %��ͨ�˲�����
ECG_filter = filter(b,a,ECG_data);
ECG_filter = diff(ECG_filter);
ECG_filter1 = abs(ECG_filter);
ECG_filter2 = filter(ones(1,5),1,ECG_filter1);  %ƽ���˲�
tshow = 100*fs:120*fs;

figure;subplot(411);plot(ECG_data(tshow));
subplot(412);plot(ECG_filter(tshow));
subplot(413);plot(ECG_filter1(tshow));
subplot(414);plot(ECG_filter2(tshow));

thr = [];
for j = 1:10
    x = ECG_filter(((j-1)*fs+1): (j*fs));
    thr(j) =  max(x);
end
thr0 = min(thr)*0.8;   %ȡ��ֵ
flag = 0 ;
i = 1;
m = 1;
RR_count = 0;
qrs = [];
hrate = [];
while (i < length(ECG_filter))
    switch(flag)
        case 0
            RR_count = RR_count + 1;
            if ECG_filter(i) > thr0   %Ѱ�Ҵ�����ֵ�ĵ�
                if ECG_filter(i) <= ECG_filter(i-1)  % R���ж�
                    if m>1
                        if RR_count <75
                            thr0 = thr0 * 1.2;    %��ֵ����
                        end
                        if RR_count>500
                            thr0 = thr0 * 0.8;     %��ֵ����
                        end
                    end
                    RR_count = 0;
                    flag = 1;
                    qrs(m) = i-1;    % QRS����
                    m = m+1;
                end          
             end
            %break;          
        case 1
             RR_count = RR_count + 1;
            if ECG_filter(i) < thr0;  % Ѱ��С����ֵ�ĵ�
                flag = 0;                
            end
            %break;
    end
    if (m-1) >=4
       count_coverage = (qrs(m-1)-qrs(m-4))/3 ;   %3��RR������ƽ��
       hrate(m-1) = 60 *250/count_coverage;     %���ʼ���
    end
    i = i + 1;
end
figure;plot(ECG_filter);xlim([1000 5000]);hold on,plot(qrs,ECG_filter(qrs),'*r');
figure;plot(hrate); %hold on, plot(m,hrate(m),'*r');
