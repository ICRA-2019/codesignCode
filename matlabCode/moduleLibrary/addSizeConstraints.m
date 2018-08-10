function [Aineq, bineq] = addSizeConstraints(Aineq, bineq, modules)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

% motor should fit on frame . size_motor < size_frame => size_motor - size_frame < 0
Asize_mat = zeros(nrFeat,nrModules);
Asize_mat(fIds.size,mIds.motor) = +1;
Asize_mat(fIds.size,mIds.frame) = -1;
Asize = Asize_mat(:)'; % stack by columns and then make row vector
bsize = 0;
Aineq = [Aineq; Asize * table];
bineq = [bineq; bsize];
clear Asize_mat Asize bsize % to make sure we do not reuse

% camera should fit on frame . size_camera < size_frame => size_camera - size_frame < 0
Asize_mat = zeros(nrFeat,nrModules);
Asize_mat(fIds.size,mIds.camera) = +1;
Asize_mat(fIds.size,mIds.frame) = -1;
Asize = Asize_mat(:)'; % stack by columns and then make row vector
bsize = 0;
Aineq = [Aineq; Asize * table];
bineq = [bineq; bsize];
clear Asize_mat Asize bsize % to make sure we do not reuse

% computer should fit on frame . size_computer < size_frame => size_computer - size_frame < 0
Asize_mat = zeros(nrFeat,nrModules);
Asize_mat(fIds.size,mIds.computer) = +1;
Asize_mat(fIds.size,mIds.frame) = -1;
Asize = Asize_mat(:)'; % stack by columns and then make row vector
bsize = 0;
Aineq = [Aineq; Asize * table];
bineq = [bineq; bsize];
clear Asize_mat Asize bsize % to make sure we do not reuse

% battery should fit on frame . size_battery < size_frame => size_battery - size_frame < 0
Asize_mat = zeros(nrFeat,nrModules);
Asize_mat(fIds.size,mIds.battery) = +1;
Asize_mat(fIds.size,mIds.frame) = -1;
Asize = Asize_mat(:)'; % stack by columns and then make row vector
bsize = 0;
Aineq = [Aineq; Asize * table];
bineq = [bineq; bsize];
clear Asize_mat Asize bsize % to make sure we do not reuse


