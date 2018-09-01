function [mIds, fIds, nrModules, nrFeat, table] = getIds(modules)

table = blkdiag(modules.motors,modules.frames,modules.cameras,modules.computerVIOs,modules.batteries);

%% module ordering
mIds.motor = 1;
mIds.frame = 2;
mIds.camera = 3;
mIds.computer = 4;
mIds.battery = 5;

nrModules = 5;

%% feature ordering (these features are common to all modules)
fIds.size = 1;
fIds.weight = 2;
fIds.voltage = 3;
fIds.current = 4;
fIds.cost = 5;

nrFeat = size(modules.motors,1);