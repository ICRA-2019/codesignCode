function frames = getFrameTable()

% number from here: https://hobbyking.com/en_us/aircraft/drones/frame-kits.html

% voltage and current are kept to preserve ordering wrt other modules
% size is only longest = length
% 1:size(m)  2:weight(g) 3:voltage(V)  4:current(A)    5:cost(pound) 6:width??(m) 7:height(m)
frames_tranpose = ...     
[ 0.290            750         0             0           22.87          0.055      0.075 % S500 Glass Fiber Quadcopter Frame 480mm - Integrated PCB Version
  0.325           1214         0             0           63.99          0.120      0.205 % Dead Cat Pro Quadcopter with Mobius Gimbal (Kit)
  0.220            195         0             0           39.11          0.035      0.110  %Stormer 220 FPV Racing Quadcopter Frame Kit
  0.230            211         0             0           44.84          0.035      0.065 % Dart 230 FPV Drone w/ Integrated PCB and LED's (Kit)
  0.195            271         0             0           9.99           0.040      0.140 % Spedix S250AQ FPV Racing Drone Frame Kit
  0.270            585         0             0           48.47          0.160      0.240 % Quanum Outlaw 270 Racing Drone Frame Kit
]; 


cost_col = 5;
poundToDollarsRate = 1.28;
frames_tranpose(:,cost_col) = frames_tranpose(:,cost_col) * poundToDollarsRate; % convert to dollars

frames = frames_tranpose';