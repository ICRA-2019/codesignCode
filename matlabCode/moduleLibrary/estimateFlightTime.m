function maxFlightTime = estimateFlightTime(modules,x)

% (Battery Capacity * 0.8 / Average Amp Draw) * 60^2 > minFlightTime [s]
xdesign = parsex(x, modules);
x_motor = xdesign(1); % index of chosen motor
x_camera = xdesign(3); % index of chosen camera
x_vio = xdesign(4); % index of chosen vio
x_battery = xdesign(5); % index of chosen battery

[~, fIds] = getIds(modules);
fIds.capacity = 7;

batteryCapacity = modules.batteries(fIds.capacity,x_battery);  % [A/h]
volt_b = modules.batteries(fIds.voltage,x_battery);

curr_m = modules.motors(fIds.current,x_motor);
volt_m = modules.motors(fIds.voltage,x_motor);

curr_c = modules.cameras(fIds.current,x_camera);
volt_c = modules.cameras(fIds.voltage,x_camera);

curr_vio = modules.cameras(fIds.current,x_vio);
volt_vio = modules.cameras(fIds.voltage,x_vio);

averageAmpDraw = ( (4 * curr_m * volt_m) + (curr_c*volt_c) + (curr_vio*volt_vio) ) / volt_b; % [4 motors]

maxFlightTime = (batteryCapacity * 0.8 / averageAmpDraw) * 60^2; 