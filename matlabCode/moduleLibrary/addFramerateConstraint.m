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
rho = 1.2; % Air density [kg/m3], 
cd =  1.3; % the drag coefficient 
c = (0.5 * rho * cd)^2;

%% define constraints:
% log(w) \geq log(k)+4log(4T)-log(c)-2log(A)-2log(m_b*g)
% log(k)+4log(4T)-log(c)-2log(A)-2log(m_b*g) - log(w) \leq 0
% +4log(4T)-2log(A)-2log(m_b*g) - log(w) \leq log(c) - log(k)
bthrust = log(c) - log(k);

% +4log(4T*g* 1e-3)-2log(A)-2log(m_b*g* 1e-3) - log(w) \leq log(c) - log(k) %% all masses in Kg
% row vectors:
a_motor = +4 * log( 4 * modules.motors(fIds.thrust,:) * g * 1e-3); 
a_frame =   -2 * log( ( modules.frames(fIds.width,:) ).^2 );
a_camera =  -log( modules.cameras(fIds.framerate,:) );  
a_computer = zeros(1,modules.nr_computerVIOs);
a_battery = -2*log( modules.batteries(fIds.weight,:) * g * 1e-3);
Athrust = [a_motor   a_frame  a_camera  a_computer  a_battery];

Aineq = [Aineq; Athrust];
bineq = [bineq; bthrust];




