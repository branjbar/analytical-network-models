%% This code provides a quick overview of cumulative 
%% degree distributions of both "uniform performance" and "strength-based performance" methods. 

close all
clear all
clc

deg1 = [];  % degree for uniform prefrence
deg2 = [];  % degree for strenght-based prefrence
N = 100000;

%% uniform prefrence
for i = 1: N
    deg1(i) = 1;
    for j = i : N
        deg1(i) = deg1(i) + 1 / i;
    end
end

%% strenght-based prefrence
for i = 1: N
    deg2(i) = 1;
    for j = i+1 : N+1
        deg2(i) = deg2(i) * (2*j - 4) / (2*j-5);
    end
end
        
%% computing the cumulative distribution
[y1, x1]= hist(deg1,100000);
y1 = cumsum(y1(end:-1:1));
y1 = y1(end:-1:1);

[y2, x2]= hist(deg2,100000);
y2 = cumsum(y2(end:-1:1));
y2 = y2(end:-1:1);

%% plotting

loglog(x1,y1,'k.')
hold on
loglog(x2,y2,'r*')
legend('uniform preference','strength-based prefrence')
xlabel('degree (log-scale)')
ylabel('cumulative frequency (log-scale)')
xlim([1,10^5])
