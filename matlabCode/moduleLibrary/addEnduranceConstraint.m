function [Aineq, bineq] = addEnduranceConstraint(Aineq, bineq, modules, minFlightTime)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

fIds.capacity = 7;
batteryDischarge = 0.8; % can only discharge 80% of the battery

% (Battery Capacity * 0.8 * /Average Amp Draw) * 60^2 > minFlightTime
% log(Battery Capacity) + log(0.8) - log(sum power/n) + log(3600) > log(minFlightTime)
% -log(Battery Capacity)  + log(sum power/n)  < -log(minFlightTime) + log(0.8) + log(3600)
% -log(Battery Capacity)  + log(power motor)  < -log(minFlightTime) + log(0.8) + log(3600)
bendurance = -log(minFlightTime) + log(batteryDischarge) + log(3600);

a_motor =    log( 4 * modules.motors(fIds.current,:) );
a_frame =    zeros(1,modules.nr_frames);
a_camera =   zeros(1,modules.nr_cameras); 
a_computer = zeros(1,modules.nr_computerVIOs);
a_battery =  -log( modules.batteries(fIds.capacity,:));
Aendurance = [a_motor   a_frame  a_camera  a_computer  a_battery];

Aineq = [Aineq; Aendurance];
bineq = [bineq; bendurance];




