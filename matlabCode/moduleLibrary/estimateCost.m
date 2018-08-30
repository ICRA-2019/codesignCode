function [cost]  = estimateCost(modules,x)

% sum of costs
xdesign = parsex(x, modules);
x_motor = xdesign(1); % index of chosen motor
x_frame = xdesign(2); % index of chosen camera
x_camera = xdesign(3); % index of chosen camera
x_vio = xdesign(4); % index of chosen vio
x_battery = xdesign(5); % index of chosen battery

[~, fIds] = getIds(modules);

cost_motor = modules.motors(fIds.cost,x_motor);
cost_frame = modules.frames(fIds.cost,x_frame);
cost_camera = modules.cameras(fIds.cost,x_camera);
cost_vio = modules.computerVIOs(fIds.cost,x_vio);
cost_battery = modules.batteries(fIds.cost,x_battery);

cost = 4*cost_motor + cost_frame + cost_camera + cost_vio + cost_battery;