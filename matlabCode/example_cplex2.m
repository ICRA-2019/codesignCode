clear all
close all
clc

% min_{x} o_r' x
% s.t.  x in {0,1}^n 
%       sum(x) = 1
% 

n=10;
f = ones(n,1);
Aineq = [];
bineq = [];
Aeq = rand(n-1,n);
beq = rand(n-1,1);
lb = zeros(n,1);
ub = ones(n,1);

Aineq = []; bineq = [];Aeq = []; beq = []; 
sostype = []; sosind = []; soswt = []; lb = []; ub = []; 
% lb = zeros(N,1); ub = ones(N,1); 
options = cplexoptimset;
options.Display = 'on';
% Set ctype(j) to 'B', 'I','C', 'S', or 'N' to 
% indicate that x(j) should be binary, general integer, 
% continuous, semi-continuous or semi-integer (respectively).
for i=1:N
   ctype(i) = 'B'; % horzcat(ctype,'B'); 
end

x = cplexlp(f,Aineq,bineq,Aeq,beq,lb,ub)

