clear all
close all
clc

% This is a variant in which sum x=1 is replaced with sum x<= 1 (graph design)

%% Assumption:
% - resources required by chassis and motor are additive or can be
% concatenated (lexicographic ordering)

%% Resources and performance at the block level
% xy = [x; y]; % this will be the optimization variable
% x: chassis
n_x=40; % number of potential chassis
% y: motor
n_y=30; % number of potential motors
% r_x = M_rx_x x = [torque speed cost total_mass]
nr_x = 4; % nr resources
% p_x = M_px_x x = [payload velocity]
np_x = 2; % nr performance
% r_y = M_ry_y y = [mass voltage current cost]
nr_y = 4; % nr resources
% p_y = M_py_y y = [torque speed]
np_y = 2; % nr performance
% number of system resources
nr = 4;
% number of system performance
np = 2;

%% Performance-resource for chassis (x)
M_px_x = rand(np_x,n_x);
M_rx_x = rand(nr_x,n_x);

%% Performance-resource for motor (y)
M_py_y = rand(np_y,n_y);
M_ry_y = rand(nr_y,n_y);

%% Resources at the system level 
% r = [totalMass cost voltage current]
% rx = [torque speed cost total_mass] 
M_r_rx = [0 0 0 1; 0 0 1 0; 0 0 0 0; 0 0 0 0];
% ry = [mass voltage current cost] 
M_r_ry = [0 0 0 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
% r = M_r_rxry [r_x; r_y]
M_r_rxry = [M_r_rx  M_r_ry];

%% Performance at the system level
% beta(extraPayload) + r_y(mass) <= p_x(payload)
% => r_y(mass) - p_x(payload) <= -beta(extraPayload)
% r_y = M_py_y y  ;  r_y(mass) = [1 0 0 0] r_y
% beta(velocity) <= p_x(velocity)
% p = [velocity extraPayload]
% rx = [torque speed cost total_mass] 
M_p_rx = [0 0 0 0; 0 0 0 0];
% ry = [mass voltage current cost] 
M_p_ry = [0 0 0 0; 1 0 0 0];
% p_x = [payload velocity]
M_p_px = [0 -1; -1 0]; 
% p_y = [torque speed]
M_p_py = [0 0; 0 0];

M_p_rxpx = [M_p_rx M_p_px]; % [rx px]
M_p_rypy = [M_p_ry M_p_py]; % [ry py]

M_rxpx_x = [M_rx_x; M_px_x];
M_rypy_y = [M_ry_y; M_py_y];

%% System performance specifications
beta_p = [-rand; -rand]; % [velocity extraPayload]

%% For each interaction among blocks
% E = edge, xy means connecting x and y, l means on the lesser side, rx is the resources involved
E_xy_l_rx = [eye(np_y) zeros(np_y, nr_x-np_y)];  
E_xy_g_py = eye(np_y);
beta_rxpy = zeros(size(E_xy_g_py,1),1);

%% Aineq x <= bineq
% this has the block structure of incidence matrix
Aineq = [M_p_rxpx * M_rxpx_x     M_p_rypy * M_rypy_y;
         E_xy_l_rx * M_rx_x     -E_xy_g_py * M_py_y;
         ones(1,n_x)  zeros(1,n_y);
         zeros(1,n_x)  ones(1,n_y)];
bineq = [beta_p; 
         beta_rxpy;
         1;
         1];
     
%% Costs
% map resources to cost
f_obj_r = rand(1,nr);
f = f_obj_r * M_r_rxry * [M_rx_x  zeros(nr_x,n_y) ; zeros(nr_y,n_x)  M_ry_y]; % min f' xy

%% Aeq x = beq (used to enforce sum(x) = 1, i.e., we choose a single motor)
Aeq = []; 
beq = [];
     
% lower and upper bound on x
lb = [];
ub = [];

% set options and optimize
options = cplexoptimset;
   options.Display = 'on';
[xy, fval, exitflag, output] = cplexbilp (f, Aineq, bineq, Aeq, beq, [], options);

xy

fval

sum(xy)

% Set ctype(j) to 'B', 'I','C', 'S', or 'N' to 
% indicate that x(j) should be binary, general integer, 
% continuous, semi-continuous or semi-integer (respectively).
% for i=1:N
%    ctype(i) = 'B'; % horzcat(ctype,'B'); 
% end