function x = designDrone(modules, specs)

%% constraints:
Aineq = [];  Aeq = [];
bineq = [];  beq = [];

%% Implicit constraint: components should fit into frame
[Aineq, bineq] = addSizeConstraints(Aineq, bineq, modules);

%% Implicit constraint: minimum thrust for flight
[Aineq, bineq] = addThrustConstraint(Aineq, bineq, modules, specs.minThrustRatio);

%% Implicit constraint: minimum power
[Aineq, bineq] = addPowerConstraint(Aineq, bineq, modules);

%% Implicit constraint: minimum frame-rate
[Aineq, bineq] = addFramerateConstraint(Aineq, bineq, modules, specs.maxPxDisplacementFrames);
[Aineq, bineq] = addFramerateVIOConstraint(Aineq, bineq, modules);

%% Implicit constraint: minimum keyframe-rate
[Aineq, bineq] = addKeyframerateConstraint(Aineq, bineq, modules, specs.maxPxDisplacementKeyframes)

%% system constraint: maximum cost
[Aineq, bineq] = addCostConstraint(Aineq, bineq, modules, specs.maxBudget);

%% system constraint: minimum flight time


%% design constraint: pick one for each module
[Aeq, beq] = addUniqueModuleConstraints(Aeq, beq, modules);

%% system objective: maximum speed

%% add endurance constraint

x = [];

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
