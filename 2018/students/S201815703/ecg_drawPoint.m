function [ Y ,X ] = ecg_drawPoint(sig,beginIndex,endIndex,boundaryValue)
%Decription: 
%Input:
%   sig: ecg signal,
%   beginIndex: 
%   endIndex:  
%   boundaryValue: 
%
%Out:
%   Y
%   X
%Author:    zhihaozhao
%History:   Create in 2018.09.24
%
sig = abs(sig);%ȡ����ֵ
Y = [];
X = [];
for li = beginIndex:endIndex
    %���boundaryValue = 40��
    %int beginIndex endIndex;
    if sig(li:li)>=boundaryValue        
        Y = [Y;sig(li:li)];
        X = [X;li-beginIndex];
    end      
end
%ȥ��
