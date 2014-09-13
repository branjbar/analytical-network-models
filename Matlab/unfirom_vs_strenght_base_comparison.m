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
    for j = i+2 : N+1
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
