clear all
close all
clc

% min_{x} o_x' x + o_y' y 
% s.t.  
%       sum(x) = 1
%       sum(y) = 1
%       O_p' x >= beta
%       C_x x >= Kxy L_y y

%% Assumption:
% - resources required by chassis and motor are additive or can be
% concatenated (lexicographic ordering)

% x: chassis
n_x=20; % number of potential chassis
% y: motor
n_y=10; % number of potential motors
% r_x = L_x x = [torque speed cost total_mass]
nr_x = 4; % nr resources
% p_x = C_x x = [payload velocity]
np_x = 2; % nr performance
% r_y = L_y y = [mass voltage current cost]
nr_y = 4; % nr resources
% p_y = C_y y = [torque speed]
np_y = 2; % nr performance
% xy = [x; y]; % this will be the optimization variable

% assigns a resource cost to each motor
f_x = rand(n_x,1);
% assigns a resource cost to each motor
f_y = rand(n_y,1);
f = [f_x; f_y]; % to multiply xy

%% Aeq x = beq (used to enforce sum(x) = 1, i.e., we choose a single motor)
Aeq = [ones(1,n_x)  zeros(1,n_y); zeros(1,n_x)  ones(1,n_y)]; 
beq = [1;1];

%% Aineq x <= bineq
% Performance requirements on x
O_pt = -10 * rand(np_x,n_x); % column-wise specified performance of i=th motor
beta = -rand(np_x,1); % this is the smallest componentwise performance

% Performance-resources requirements on x and y
C_x = rand(nr_x,n_x);
Kxy = [eye(np_y) zeros(np_y, nr_x-np_y)];
L_y = rand(np_y,n_y);

Aineq = [O_pt  zeros(np_x,n_y);  
         -L_y   Kxy*C_x];
bineq = [beta  ;  
         zeros(size(L_y,1),1)];

% lower and upper bound on x
lb = [];
ub = [];

% set options and optimize
options = cplexoptimset;
   options.Display = 'on';
[xy, fval, exitflag, output] = cplexbilp (f, Aineq, bineq, Aeq, beq, [], options);

xy

fval

% Set ctype(j) to 'B', 'I','C', 'S', or 'N' to 
% indicate that x(j) should be binary, general integer, 
% continuous, semi-continuous or semi-integer (respectively).
% for i=1:N
%    ctype(i) = 'B'; % horzcat(ctype,'B'); 
% end