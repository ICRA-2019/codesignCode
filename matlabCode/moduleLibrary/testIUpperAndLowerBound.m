clear all
close all
clc

%% lower bound
n = 5;
for i=1:1000
    a = 1+10*rand(n,1);
    value = log(sum(a));
    lowerBound = sum(log(a)) / n + log(n);
    relErr(i) = (value - lowerBound) / value;
end
figure
plot(relErr) % around 10% and gets smaller for larger n
title('lower bound quality')

%% upper bound from https://math.stackexchange.com/questions/576774/unlike-jensens-inequality-can-we-upper-bound-log-sum-iu-i-expx-i
for i=1:1000
    a = 1+10*rand(n,1); 
    mi = 1;
    ma = 1+10;
    value = log(sum(a))
    upperBound = log(n) + log(max(a));
    % sum(log(a)) + log(mi) + log(ma) - log((mi+ma)/2) % f(min) + f(max) - f((min+max)/2)
    relErr(i) = (upperBound - value) / value;
end
figure
plot(relErr) % around 10% and gets smaller for larger n
title('upper bound quality')




