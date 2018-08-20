function [Aineq, bineq] = addKeyframerateConstraint(Aineq, bineq, modules, maxPxDisplacementKeyframes, meanGroundDistance, fracMaxSpeed)
%% (Aineq x <= bineq)
if nargin < 6
    fracMaxSpeed = 1; % consider full speed
end

%% vectorization requires deciding an ordering for the modules and the features
[mIds, fIds, nrModules, nrFeat, table] = getIds(modules);

fIds.width = 6;
fIds.backendRate = 7;
fIds.thrust = 6;

%% define constants:
% parameters from: https://klsin.bpmsg.com/how-fast-can-a-quadcopter-fly/
g = 9.81; %[m/s^2]
minDistance = meanGroundDistance; % min distance to obstacles
f = 320; % focal length (px/m) % assume fixed for all cameras
k = f / (maxPxDisplacementKeyframes * minDistance);
rho = 1.2; % Air density [kg/m3], 
cd =  1.3; % the drag coefficient 
c = (0.5 * rho * cd)^2;

%% define constraints:
% w > k * v
% w^4 > k^4 * T^4 / (c * A^2 * (mg)^2)
% 4log(w) \geq 4log(k)+4log(4T)-log(c)-2log(A)-2log(m_b*g)
% 4log(k)+4log(4T)-log(c)-2log(A)-2log(m_b*g) - 4log(w) \leq 0
% +4log(4T)-2log(A)-2log(m_b*g) - 4log(w) \leq log(c) - 4log(k)
%
% WITH MARGIN:
% w > percMaxSpeed * k * v    [0< percMaxSpeed< 1]
% w^4 > percMaxSpeed^4 * k^4 * T^4 / (c * A^2 * (mg)^2)
% 4log(w) \geq 4log(percMaxSpeed) +% 4log(k)+4log(4T)-log(c)-2log(A)-2log(m_b*g) 
% 4log(percMaxSpeed) + 4log(k)+4log(4T)-log(c)-2log(A)-2log(m_b*g) - 4log(w) \leq 0
% +4log(4T)-2log(A)-2log(m_b*g) - 4log(w) \leq log(c) - 4log(k) - 4log(percMaxSpeed)
bthrust = log(c) - 4*log(k) - 4*log(fracMaxSpeed);

% +4log(4T*g* 1e-3)-2log(A)-2log(m_b*g*1e-3) - 4log(w) \leq log(c) - 4log(k) %% all masses in Kg
% row vectors:
a_motor = +4 * log( 4 * modules.motors(fIds.thrust,:) * 1e-3 * g ); 
a_frame =   -2 * log( ( modules.frames(fIds.size,:) ).^2 );
a_camera =  zeros(1,modules.nr_cameras); 
a_computer = -4*log( modules.computerVIOs(fIds.backendRate,:) ); 
a_battery = -2*log( modules.batteries(fIds.weight,:) * 1e-3 * g );
Athrust = [a_motor   a_frame  a_camera  a_computer  a_battery];

Aineq = [Aineq; Athrust];
bineq = [bineq; bthrust];




