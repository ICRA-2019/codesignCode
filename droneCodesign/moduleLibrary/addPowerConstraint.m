function [Aineq, bineq] = addPowerConstraint(Aineq, bineq, modules)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

% sum powers components < power battery => sum powers components - power battery < 0
Avoltage_mat = zeros(nrFeat,nrModules);
Avoltage_mat(fIds.voltage,mIds.motor) = +1; 
Avoltage_mat(fIds.voltage,mIds.frame) = +1;
Avoltage_mat(fIds.voltage,mIds.camera) = +1;
Avoltage_mat(fIds.voltage,mIds.computer) = +1;
Avoltage_mat(fIds.voltage,mIds.battery) = +1;
Avoltage = Avoltage_mat(:)' * table; % stack by columns and then make row vector

Acurrent_mat = zeros(nrFeat,nrModules);
Acurrent_mat(fIds.current,mIds.motor) = +4; % 4 times since we have 4 motors
Acurrent_mat(fIds.current,mIds.frame) = +1;
Acurrent_mat(fIds.current,mIds.camera) = +1;
Acurrent_mat(fIds.current,mIds.computer) = +1;
Acurrent_mat(fIds.current,mIds.battery) = -1; % minus to make right sign into inequality
Acurrent = Acurrent_mat(:)' * table; % stack by columns and then make row vector

bpower = 0;
Apower = Avoltage .* Acurrent;
Aineq = [Aineq; Apower];
bineq = [bineq; bpower];




