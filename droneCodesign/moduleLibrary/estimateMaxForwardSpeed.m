function maxVel = estimateMaxForwardSpeed(modules,x)

g = 9.81; %[m/s^2] % magnitude of gravity
rho = 1.2; % Air density [kg/m3],
cd =  1.3; % the drag coefficient
c = (0.5 * rho * cd)^2;

xdesign = parsex(x, modules);
x_motor = xdesign(1); % index of chosen motor
x_frame = xdesign(2); % index of chosen frame
x_camera = xdesign(3); % index of chosen camera
x_vio = xdesign(4); % index of chosen vio
x_battery = xdesign(5); % index of chosen battery

[mIds, fIds] = getIds(modules);
fIds.thrust = 6;

T = modules.motors(fIds.thrust,x_motor); %[g] - thrust of each motor
A = modules.frames(fIds.size,x_frame)^2; %[m^2] - area of drone
mass_m = modules.motors(fIds.weight,x_motor); %[g]
mass_f = modules.frames(fIds.weight,x_frame); %[g]
mass_c = modules.cameras(fIds.weight,x_camera); %[g]
mass_vio = modules.computerVIOs(fIds.weight,x_vio); %[g]
mass_b = modules.batteries(fIds.weight,x_battery); %[g]
m = mass_m + mass_f + mass_c + mass_vio + mass_b;

maxVel = exp( (+4*log(4*T*g*1e-3)-2*log(A)-2*log(m*g*1e-3)-log(c)) / 4); 