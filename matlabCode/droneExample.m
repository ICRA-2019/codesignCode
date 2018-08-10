% Codesign of an autonomous drone racing platform
% Author: Luca Carlone
% Date: 08/08/2018
clear all
close all
clc

addpath('./moduleLibrary')

%% Modules to design, each one described by a matrix: features vs module choice
% preferred row order:
% 1: size
% 2: weight
% 3: voltage
% 4: current 
% 5: cost
% 6: other (thrust, framerate, etc, depending on module)

% get tables for each module
modules.motors = getMotorTable();
modules.frames = getFrameTable();
modules.cameras = getCameraTable();
modules.computerVIOs = getComputerVIOTable();
modules.batteries = getBatteryTable();
[modules,maxNrFeatures] = padTablesWithZeros(modules); % for simplicity we assume a max feature size and pad smaller size with zeros

%% Dimensionality of variables
modules.nr_motors = size(modules.motors,2);
modules.nr_frames = size(modules.frames,2);
modules.nr_cameras = size(modules.cameras,2);
modules.nr_computerVIOs = size(modules.computerVIOs,2);
modules.nr_batteries = size(modules.batteries,2);

%% Implicit constraints:
Aineq = [];
bineq = [];

%% Implicit constraint: components should fit into frame
[Aineq, bineq] = addSizeConstraints(Aineq, bineq, modules);

%% Implicit constraint: minimum thrust for flight
[Aineq, bineq] = addThrustConstraint(Aineq, bineq, modules);

%% Implicit constraint: minimum power

%% Implicit constraint: minimum frame-rate

%% Implicit constraint: minimum keyframe-rate

%% system constraint: maximum cost
 
%% system constraint: minimum flight time

%% design constraint: pick one for each module

%% system objective: maximum speed

% %% Costs
% % map resources to cost
% f_obj_r = rand(1,n_r);
% %                x       y      z_xy
% f = f_obj_r * [M_r_x   M_r_y  M_r_zxy]; % min f' xy
% 
% %% Aeq x = beq (used to enforce sum(x) = 1, i.e., we choose a single motor)
% Aeq = [ones(1,n_x)  zeros(1,n_y)    zeros(1,n_zxy); 
%        zeros(1,n_x)  ones(1,n_y)    zeros(1,n_zxy);
%        zeros(1,n_x)  zeros(1,n_y)   ones(1,n_zxy)]; 
% beq = [1;1;1];
%      
% % lower and upper bound on x
% lb = [];
% ub = [];
% 
% % set options and optimize
% options = cplexoptimset;
%    options.Display = 'on';
% [xyz, fval, exitflag, output] = cplexbilp (f, Aineq, bineq, Aeq, beq, [], options);
% 
% xyz
% 
% fval
