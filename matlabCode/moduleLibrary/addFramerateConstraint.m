function [Aineq, bineq] = addFramerateConstraint(Aineq, bineq, modules, maxPxDisplacementFrames)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

fIds.width = 6;
fIds.framerate = 6;
fIds.thrust = 6;

%% define constants:
% parameters from: https://klsin.bpmsg.com/how-fast-can-a-quadcopter-fly/
g = 9.81; %[m/s^2]
minDistance = 1; % min distance to obstacles
f = 320; % focal length (px/m) % assume fixed for all cameras
k = f / (maxPxDisplacementFrames * minDistance);
rho = 1200; % Air density [g/m3], 
cd =  1.3; % the drag coefficient 
c = (0.5 * rho * cd)^2;

%% define constraints:
% log(?) geq log(k)+ 4*log(4T)?log(c)?2*log(A)?2*log(m_b g)
% log(?) - 4*log(4T) + 2*log(A) + 2*log(m_b g) leq log(k)?log(c) 
bthrust = log(k) - log(c);

% - 4*log(4T) + 2*log(A) + log(?) + 2*log(m_b g) leq log(k)?log(c) 
% row vectors:
a_motor = - 4 * log( 4 * modules.motors(fIds.thrust,:) );
a_frame =   2 * log( ( modules.frames(fIds.width,:) ).^2 );
a_camera =      log( modules.cameras(fIds.framerate,:) );  
a_computer = zeros(1,modules.nr_computerVIOs);
a_battery = 2*log( modules.batteries(fIds.weight,:) * g);
Athrust = [a_motor   a_frame  a_camera  a_computer  a_battery];

Aineq = [Aineq; Athrust];
bineq = [bineq; bthrust];




