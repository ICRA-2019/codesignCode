function [Aineq, bineq] = addThrustConstraint(Aineq, bineq, modules, minThrustRatio)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

fIds.thrust = 6;

% Motor_trust X nrMotors > minThrustRatio * sum weight components => 
% minThrustRatio * sum weight components - Motor_trust X nrMotors < 0
Athrust_mat = zeros(nrFeat,nrModules);
Athrust_mat(fIds.thrust,mIds.motor) = -4; % 4 times since we have 4 motors
Athrust_mat(fIds.weight,mIds.motor) = +minThrustRatio;
Athrust_mat(fIds.weight,mIds.frame) = +minThrustRatio;
Athrust_mat(fIds.weight,mIds.camera) = +minThrustRatio;
Athrust_mat(fIds.weight,mIds.computer) = +minThrustRatio;
Athrust_mat(fIds.weight,mIds.battery) = +minThrustRatio;
Athrust = Athrust_mat(:)'; % stack by columns and then make row vector
bthrust = 0;
Aineq = [Aineq; Athrust * table];
bineq = [bineq; bthrust];




