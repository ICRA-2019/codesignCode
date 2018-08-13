function f = maxSpeedObjective(modules)
%% (Aineq x <= bineq)
 
%% vectorization requires deciding an ordering for the modules and the features
[~, fIds, ~, ~, ~] = getIds(modules);

fIds.width = 6;
fIds.thrust = 6;

% max v_lower_bound = min - v_lower_bound = min( 2log(A) - 2log(T) )
f_motor =  -2 * log( 4 * modules.motors(fIds.thrust,:) );
f_frame =   2 * log( ( modules.frames(fIds.width,:) ).^2 ); % 2 log(A) = 2 log(l^2)
f_camera =     zeros(1,modules.nr_cameras);     
f_computer =   zeros(1,modules.nr_computerVIOs);
f_battery =    zeros(1,modules.nr_batteries);
f = [f_motor   f_frame  f_camera  f_computer  f_battery];






