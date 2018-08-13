function [Aineq, bineq] = addKeyframerateVIOConstraint(Aineq, bineq, modules)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

fIds.framerate = 6;
fIds.frontendRate = 6;

% fcamera < fvio => fcamera - fvio <= 0
Af_mat = zeros(nrFeat,nrModules);
Af_mat(fIds.framerate,mIds.camera) = +1;
Af_mat(fIds.frontendRate,mIds.computer) = -1;
Af = Af_mat(:)'; % stack by columns and then make row vector
bf = 0;
Aineq = [Aineq; Af * table];
bineq = [bineq; bf];




