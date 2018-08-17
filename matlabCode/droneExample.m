% Codesign of an autonomous drone racing platform
% Author: Luca Carlone
% Date: 08/08/2018
clear all
close all
clc

%% start by running unit tests
addpath('./tests')
clc; run(testDesignDrone);

%% run actual example
addpath('./moduleLibrary')

%% Modules to design, each one described by a matrix: features vs module choice
% preferred row order:
% 1: size
% 2: weight
% 3: voltage
% 4: current 
% 5: cost
% 6: other (thrust, framerate, etc, depending on module)

% get tables for each module
modules.motors = getMotorTable();
modules.frames = getFrameTable();
modules.cameras = getCameraTable();
modules.computerVIOs = getComputerVIOTable();
modules.batteries = getBatteryTable();
[modules,maxNrFeatures] = padTablesWithZeros(modules); % for simplicity we assume a max feature size and pad smaller size with zeros

%% Dimensionality of variables
modules.nr_motors = size(modules.motors,2);
modules.nr_frames = size(modules.frames,2);
modules.nr_cameras = size(modules.cameras,2);
modules.nr_computerVIOs = size(modules.computerVIOs,2);
modules.nr_batteries = size(modules.batteries,2);

%% system constraints
specs.maxBudget = 3000; % [$]
specs.minThrustRatio = 2; % []
specs.minFlightTime = 60 * 15; % [s] = 15 min
specs.maxPxDisplacementFrames = 30; % [px]
specs.maxPxDisplacementKeyframes = 100; % [px]

%% design!
x = designDrone(modules, specs);

warning('VIO frontend should be faster than camera to be feasible')