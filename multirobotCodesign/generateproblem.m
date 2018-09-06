% Codesign of a swarm of robots performing collective transport
% Author: Carlo Pinciroli
% Date: 05/09/2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% oradius = radius of object [cm]
% oweight = weight of object [kg]
% cnum    = number of chassis in catalog
% snum    = number of sensors in catalog
% mnum    = number of motors in catalog
% bnum    = number of batteries in catalog

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%
% robots    = maximum number of robots
%
% cweight   = weight of chassis      [kg]
% cradius   = radius of chassis      [cm]
% csize     = size of chassis        [cm^2]
%
% scoverage = coverage of sensor     [% of perimeter]
% spower    = power needed by sensor [W]
% sweight   = weight of sensor       [N]
% ssize     = size of sensor         [m^2]
%
% mforce    = force exerted by motors [Newton]
% mpower    = power needed by motor   [W]
% mweight   = weight of motors        [N]
% msize     = size of motor           [m^2]
%
% bpower    = power given by battery  [W]
% bweight   = weight of battery       [kg]
% bsize     = size of battery         [m^2]

function [robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize] = generateproblem(oradius, oweight, cnum, snum, mnum, bnum)

%%%%%%%%%%%%%%%%%%%%
% Chassis
% The smallest has a radius of 10cm
% The largest has a radius of 30cm
cradius = linspace(0.1, 0.30, cnum);
csize   = pi * (cradius .* cradius);
% The weight is proportional to the area (constant density)
cweight = 20 * csize;

%%%%%%%%%%%%%%%%%%%%
% Number of robots
% The maximum is calculated using the radius of the smallest chassis
robots = ceil(pi * (oradius + cweight(1)) / cweight(1));

%%%%%%%%%%%%%%%%%%%%
% Sensors
% Coverage
scoverage = linspace(1.0 / robots, 100.0, snum);
% Size is expressed wrt the chassis area
ssize = linspace(csize(1) * 0.2, csize(cnum) * 0.2, snum);
% Weight is proportional to the area (constant density)
sweight = 10 * ssize;
% Power consumption goes as the square of the coverage
spower = linspace(0.1, 5, snum);

%%%%%%%%%%%%%%%%%%%%
% Motors
% We assume forces exceed by 50% the minimum and maximum chassis weight
mforce = linspace(cweight(1) * 1.5, cweight(cnum) * 1.5, mnum);
% Weight is 10% of the exerted force
mweight = 0.1 * mforce;
% Size is proportional to weight
msize = mweight / 30;
% Power is proportional to force
mpower = mforce / 5;

%%%%%%%%%%%%%%%%%%%%
% Batteries
% Minimum and maximum power referred to the smallest and largest configurations
bpower = linspace(mpower(1)+spower(1), mpower(mnum)+spower(snum), bnum);
% Size is proportional to power
bsize = 0.05 * bpower;
% Weight is proportional to size
bweight = 0.1 * bsize;
