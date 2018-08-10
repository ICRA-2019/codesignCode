function [Aineq, bineq] = addThrustConstraint(Aineq, bineq, modules)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

fIds.thrust = 6;

% Motor_trust X nrMotors > sum weight components => 
% sum weight components - Motor_trust X nrMotors < 0
Athrust_mat = zeros(nrFeat,nrModules);
Athrust_mat(fIds.thrust,mIds.motor) = -4; % 4 times since we have 4 motors
Athrust_mat(fIds.weight,mIds.motor) = +1;
Athrust_mat(fIds.weight,mIds.frame) = +1;
Athrust_mat(fIds.weight,mIds.camera) = +1;
Athrust_mat(fIds.weight,mIds.computer) = +1;
Athrust_mat(fIds.weight,mIds.battery) = +1;
Athrust = Athrust_mat(:)'; % stack by columns and then make row vector
bthrust = 0;
Aineq = [Aineq; Athrust * table];
bineq = [bineq; bthrust];




