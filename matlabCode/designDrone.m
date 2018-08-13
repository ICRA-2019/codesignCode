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
[Aineq, bineq] = addKeyframerateConstraint(Aineq, bineq, modules, specs.maxPxDisplacementKeyframes);

%% system constraint: maximum cost
[Aineq, bineq] = addCostConstraint(Aineq, bineq, modules, specs.maxBudget);

%% system constraint: minimum flight time
[Aineq, bineq] = addEnduranceConstraint(Aineq, bineq, modules, specs.minFlightTime);

%% design constraint: pick one for each module
[Aeq, beq] = addUniqueModuleConstraints(Aeq, beq, modules);

%% system objective: maximum speed
f = maxSpeedObjective(modules);

%% solve optimization problem:     
% lower and upper bound on x
lb = [];
ub = [];

% set options and optimize
options = cplexoptimset;
options.Display = 'on';
[x, fval, exitflag, output] = cplexbilp (f, Aineq, bineq, Aeq, beq, [], options);

if isempty(x)==0
    fprintf('optimal objective: %g\n',fval);
    disp('optimal solution')
    disp(x')
    xdesign = parsex(x, modules);
    fprintf('- use motor: %d\n',xdesign(1));
    fprintf('- use frame: %d\n',xdesign(2));
    fprintf('- use camera: %d\n',xdesign(3));
    fprintf('- use computer: %d\n',xdesign(4));
    fprintf('- use battery: %d\n',xdesign(5));
else
    disp('design problem not feasible')
end