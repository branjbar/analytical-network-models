close all
clear all
clc

deg1 = [];
deg2 = [];
N = 100000;

for i = 1: N
    deg1(i) = 0;
    deg2(i) = 1;
    for j = i : N
        deg1(i) = deg1(i) + 1 / i;
        deg2(i) = deg2(i) * (2*j + 1) / (2*j);
    end
end
        

[y1, x1]= hist(deg1,100000);
y1 = cumsum(y1(end:-1:1));
y1 = y1(end:-1:1);

[y2, x2]= hist(deg2,100000);
y2 = cumsum(y2(end:-1:1));
y2 = y2(end:-1:1);


loglog(x1,y1,'.')
hold on
loglog(x2,y2,'r.')
legend('uniform preference','strength-based prefrence')
xlabel('degree (log-scale)')
ylabel('cumulative frequency (log-scale)')
