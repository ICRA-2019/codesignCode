function [Aineq, bineq] = addCostConstraint(Aineq, bineq, modules, maxBudget)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

% sum costs < maxBudget 
Asize_mat = zeros(nrFeat,nrModules);
Asize_mat(fIds.cost,mIds.motor) = +1;
Asize_mat(fIds.cost,mIds.frame) = +1;
Asize_mat(fIds.cost,mIds.camera) = +1;
Asize_mat(fIds.cost,mIds.computer) = +1;
Asize_mat(fIds.cost,mIds.battery) = +1;
Asize = Asize_mat(:)'; % stack by columns and then make row vector
bsize = maxBudget;
Aineq = [Aineq; Asize * table];
bineq = [bineq; bsize];
