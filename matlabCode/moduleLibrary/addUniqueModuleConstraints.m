function [Aeq, beq] = addUniqueModuleConstraints(Aeq, beq, modules)
%% (Aeq x == bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[~, ~, nrModules, ~, ~] = getIds(modules);

% unique module choices
Aunique = blkdiag(ones(1,modules.nr_motors), ...
    ones(1,modules.nr_frames), ...
    ones(1,modules.nr_cameras), ...
    ones(1,modules.nr_computerVIOs), ...
    ones(1,modules.nr_batteries));
bunique = ones(nrModules,1);
Aeq = [Aeq; Aunique];
beq = [beq; bunique];




