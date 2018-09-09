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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Budgets
% Size [m] and [m^2]
cradius = linspace(0.10, 0.30, cnum);
csize   = pi * (cradius .* cradius);
% Robots
robots  = floor(pi*(cradius(1)+oradius)/cradius(1));
% Lift force [N]
mforce = 9.81 * linspace(0.1, 10, mnum);
% Power [W]
bpower = linspace(0.5, 5, bnum);
% Sensing
scoverage = linspace(10.0, 33.0, snum);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Costs
% Size
ssize = 0.20 * linspace(csize(1), csize(cnum), snum);
msize = 0.10 * linspace(csize(1), csize(cnum), mnum);
bsize = 0.05 * linspace(csize(1), csize(cnum), bnum);
% Weight

cweight = 0.10 * linspace(mforce(1), mforce(mnum), cnum);
sweight = 0.10 * linspace(mforce(1), mforce(mnum), snum);
mweight = 0.25 * mforce;
bweight = 0.05 * linspace(mforce(1), mforce(mnum), bnum);
% Power
spower = 0.25 * linspace(bpower(1), bpower(cnum), snum);
mpower = 0.25 * linspace(bpower(1), bpower(cnum), mnum);
