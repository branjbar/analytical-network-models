%% This code provides a quick overview of cumulative 
%% degree distributions of both "uniform performance" and "strength-based performance" methods. 

%close all
clear all
clc

deg1 = [];  % degree for uniform prefrence
deg2 = [];  % degree for strenght-based prefrence
N = 10000;

%% uniform prefrence
for i = 1: N
    deg1(i) = 1;
    for j = i : N-1
        deg1(i) = deg1(i) + 1 / j;
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
[y1, x1]= hist(deg1,10);
y1c = cumsum(y1(end:-1:1));
y1c = y1c(end:-1:1);

[y2, x2]= hist(deg2,380);
y2c = cumsum(y2(end:-1:1));
y2c = y2c(end:-1:1);

% plotting
%close all
figure(1)
hold off
semilogy(x1,y1,'ko')
hold on
semilogy(x1,y1c,'r*')
xx = [0:.1:10];
semilogy(xx,(N+1)* 2.72 * exp(-(xx)),'-','linewidth', 2)
%semilogy(xx, (N+1)* 2.7 * exp(-(xx)),':','linewidth', 2)
ylim([1,10^4])
legend('DF','CCDF','y=2.72(N+1)e^{-x}','y=0.3Ne^{-x}')
xlabel('degree')
ylabel('freq.')
xlim([1,10])
%
figure(2)
loglog(x2,y2,'ko')
hold on
loglog(x2,y2c,'r*')
xx = [1:.1:100];
loglog(xx,(N-1)*xx.^-2,'-','linewidth', 2)
loglog(xx,(N-1)*xx.^-3,':','linewidth', 2)
ylim([1,10^4])
legend('DF','CCDF','y=(N-1)x^{-2}','y=(N-1)x^{-3}')
xlabel('degree (log-scale)')
ylabel('freq.')
xlim([1,10^2])



%% closeness

% SA Edge Weight
wsa = [];
dsa = [];
for i = N : -1 : 1
    for j = 1 : i -1
        wsa(i,j) = 1 / (2*i - 2);
        for k = 1 : i-j
            wsa(i,j) = wsa(i,j) * (2*i - 2*k) / (2*i - 2*k - 1);
        end
        dsa(i,j) = 1 / wsa(i,j);
        dsa(j,i) = 1 / wsa(i,j);
        wsa(j,i) = wsa(i,j);
    end
end

% UA Edge Weight
wua = [];
dua = [];
for i = N : -1 : 1
    for j = 1 : i -1
        wua(i,j) = 1 / (i-1);

        dua(i,j) = 1 / wua(i,j);
        dua(j,i) = 1 / wua(i,j);
        wua(j,i) = wua(i,j);
    end
end


% closeness centrality 

Csa = [];
Cua = [];
for i = 1 : N
    Csa(i) = 0;
    Cua(i) = 0;
    for j = 1 : N
        if i ~= j
            Csa(i) = Csa(i) + dsa(i,1) + dsa(j,1);
            Cua(i) = Cua(i) + dua(i,j);
        end
    end
    Csa(i) = 1 / Csa(i);
    Cua(i) = 1 / Cua(i);

end
Cua = Cua / max(Cua);
Csa = Csa / max(Csa);
