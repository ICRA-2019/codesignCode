clear all
close all
clc

%% Note:
% here we modify example 23 to include an extra continuous variable for the
% battery. In particular, the battery block is defined by 2 variables 
% [model  dimension], such that 
% - model = 1,...,n_y
% - dimension is a real positive number
% what is the performance of the PSU? what are the resources?
% 
% Example of motor&propeller for drone:
% m = [motor prop_length]
% - performance: 
%   lift = fun(m)  -   for drone example: F_thrust = (rho A v^2) / 2
%   where A is the area
% - resources:
%   power: P = (rho A v^3) / 2
%  A * (V b) where b constains the binary choice of motor and V associates a 
%  top speed to each motor choice
%
% In a real problem, we have $F_thrust >= weight(design) * gravity$ 
% weight(design) = sum_modules weight_i
% constraint: weight(design) * gravity - F_thrust <= 0
% - weight should be convex, and F_thrust should be concave.
% (rho A v^2) / 2 >= sum_i w_i b_i * gravity
% log(rho/2) + log(A) + log(v^2) >= log(sum_i w_i b_i * gravity)

%% Dimensionality of variables
% xy = [x; y]; % this will be the optimization variable

% x: MCB
n_x=40; % number of potential MCB
% r_x = M_rx_x x = [cost mass voltage_in current_in]
nr_x = 4; % nr resources
% p_x = M_px_x x = [current_out voltage_out]
np_x = 2; % nr performance

% y: PSU
n_y=30; % number of potential PSU
% r_y = M_ry_y y = [cost mass]
nr_y = 2; % nr resources
% p_y = M_py_y y = [current_out voltage_out capacity]
np_y = 3; % nr performance

% z_xy: overparametrization that allows representing nonlinear interactions
n_zxy = n_x * n_y;

% SYSTEM
% number of system resources
n_r = 2;
% number of system performance
n_p = 3;

%% Performance-resource for MCB (x)
M_px_x = rand(np_x,n_x);
M_rx_x = rand(nr_x,n_x);

%% Performance-resource for PSU (y)
M_py_y = rand(np_y,n_y);
M_ry_y = rand(nr_y,n_y);

%% Resources at the system level 
% r = [cost mass]
% rx = [cost mass voltage input] 
M_r_x = [1 0 0 0; 0 1 0 0] * M_rx_x;
% ry = [cost mass] 
M_r_y = [1 0; 0 1] * M_ry_y;
M_r_zxy = zeros(n_r,n_zxy);

%% Performance at the system level
% f(r_x, e) <= P p_y  -> no need to introduce z
% f(r_x, e) <= P p_y
% e >= beta(endurance)
% we rewrite it as follows, which allows eliminating the "e"
% beta(endurance) <= e <= P p_y / power_x
% f_2(x,y) = P p_y / power_x
% w <= f(x,y) = f * z => w <= f*z
f_2_mat = zeros(n_x, n_y);
for i=1:n_x
    for j=1:n_y
       f_2_mat(i,j) = M_py_y(3,j) / ( M_rx_x(3,i) * M_rx_x(4,i) );  
    end
end
% Z_xy in {0;1}^n_x,n_y
% 1' * (Z_xy .* f_2_mat) * 1 >= beta(endurance)
% Ax <= b
% vec(1' * (Z_xy .* f_2_mat) * 1) >= beta(endurance)
% using: vec(ABC) = (C' kron A) vec(B)  (wiki: vectorization)
% (1' kron 1) vec(Z_xy .* f_2_mat) = vec(f_2_mat)' * vec(Z_xy)
M_p_x = [1 0; 0 1; 0 0] * M_px_x;
M_p_y = zeros(n_p, n_y);
M_p_zxy = [zeros(2,n_zxy); vec(f_2_mat)'];

%% System performance specifications
beta_p = rand(3,1); % [voltage current endurance]
% This is the constraint we want to add
% M_p_x * x + M_p_y * y + M_p_zxy *z >= beta_p

%% For each interaction among blocks
n_exy = 2; % number of interactions between x and y
% E = edge, xy means connecting x and y, l means on the lesser side, x is the resources involved
% rx = [cost mass voltage input] 
E_xy_l_x = [zeros(2,2) eye(2)] * M_rx_x;  
% py = [voltage current capacity]
E_xy_g_y =[eye(2) zeros(2,1)] * M_py_y;
beta_xy = zeros(2,1);
% This is the constraint we want to add
% E_xy_l_x * x <= E_xy_g_y * y

%% Interactions among x, y, z_xy
% Z_xy(i,j) <= ( x(i) + y(j) )  / 2
% sum(Z_xy) = 1 
E_xyz_l_z = eye(n_zxy);
E_xyz_g_x = zeros(n_zxy,n_x);
E_xyz_g_y = zeros(n_zxy,n_y);
rowId = 0;
for i=1:n_x
    for j=1:n_y
        rowId = rowId+1;
        E_xyz_g_x(rowId,i) = 1/2;
        E_xyz_g_y(rowId,j) = 1/2;
    end
end
beta_xyz = zeros(n_zxy,1);
% This is the constraint we want to add
% E_xyz_l_z z <= E_xyz_g_x * x + E_xyz_g_y * y

%% Aineq x <= bineq
% this has the block structure of incidence matrix
%         x                    y              z_xy
Aineq = [-M_p_x               -M_p_y        -M_p_zxy;
         E_xy_l_x          -E_xy_g_y    zeros(n_exy, n_zxy)
        -E_xyz_g_x         -E_xyz_g_y      E_xyz_l_z];
bineq = [-beta_p; 
         beta_xy;
         beta_xyz];
     
%% Costs
% map resources to cost
f_obj_r = rand(1,n_r);
%                x       y      z_xy
f = f_obj_r * [M_r_x   M_r_y  M_r_zxy]; % min f' xy

%% Aeq x = beq (used to enforce sum(x) = 1, i.e., we choose a single motor)
Aeq = [ones(1,n_x)  zeros(1,n_y)    zeros(1,n_zxy); 
       zeros(1,n_x)  ones(1,n_y)    zeros(1,n_zxy);
       zeros(1,n_x)  zeros(1,n_y)   ones(1,n_zxy)]; 
beq = [1;1;1];
     
% lower and upper bound on x
lb = [];
ub = [];

% set options and optimize
options = cplexoptimset;
   options.Display = 'on';
[xyz, fval, exitflag, output] = cplexbilp (f, Aineq, bineq, Aeq, beq, [], options);

xyz

fval

% Set ctype(j) to 'B', 'I','C', 'S', or 'N' to 
% indicate that x(j) should be binary, general integer, 
% continuous, semi-continuous or semi-integer (respectively).
% for i=1:N
%    ctype(i) = 'B'; % horzcat(ctype,'B'); 
% end