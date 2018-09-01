function xdesign = parsex(x, modules)

motorIds = [1:modules.nr_motors];
frameIds = [1:modules.nr_frames];
cameraIds = [1:modules.nr_cameras];
computerIds = [1:modules.nr_computerVIOs];
batteryIds = [1:modules.nr_batteries];

X = blkdiag(motorIds,frameIds,cameraIds,computerIds,batteryIds);
xdesign = X * x;

xdesign_round = round(xdesign);

if norm(xdesign - xdesign_round) > 1e-6
   error('parsex problem') 
end

xdesign = xdesign_round;