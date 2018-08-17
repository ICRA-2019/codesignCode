function xdesign = parsex(x, modules)

motorIds = [1:modules.nr_motors];
frameIds = [1:modules.nr_frames];
cameraIds = [1:modules.nr_cameras];
computerIds = [1:modules.nr_computerVIOs];
batteryIds = [1:modules.nr_batteries];

X = blkdiag(motorIds,frameIds,cameraIds,computerIds,batteryIds);
xdesign = X * x;