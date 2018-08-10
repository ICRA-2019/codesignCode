clear all
close all
clc

% min_{x} o_r' x
% s.t.  x in {0,1}^n 
%       sum(x) = 1
%       O_p' x >= beta

n=20; % number of potential motors
% x denotes the choice of 1 out of n motors

% assigns a resource cost to each motor
f = rand(n,1); % = o_r

% Aeq x = beq (used to enforce sum(x) = 1, i.e., we choose a single motor)
Aeq = ones(1,n); 
beq = 1;

% Aineq x <= bineq
m = 6; % number of performance requirements
Aineq = -10 * rand(m,n); % column-wise specified performance of i=th motor
bineq = -rand(m,1); % this is the smallest componentwise performance

% lower and upper bound on x
lb = [];
ub = [];

% set options and optimize
options = cplexoptimset;
   options.Display = 'on';
[x, fval, exitflag, output] = cplexbilp (f, Aineq, bineq, Aeq, beq, [], options);

x

fval

% Set ctype(j) to 'B', 'I','C', 'S', or 'N' to 
% indicate that x(j) should be binary, general integer, 
% continuous, semi-continuous or semi-integer (respectively).
% for i=1:N
%    ctype(i) = 'B'; % horzcat(ctype,'B'); 
% end