function [x,maxVel,maxFlightTime_minutes,cost] = droneExample(specs,testCombinations)
% Codesign of an autonomous drone racing platform
% Author: Luca Carlone
% Date: 08/08/2018
% clear all
close all
clc

if nargin < 1
    %% system constraints
    specs.maxBudget = 10000; % [$]
    specs.minThrustRatio = 2; % []
    specs.minFlightTime = 60 * 10; % [s] = X min
    % batteryCapacity = 10/60 * AverageAmpDraw / 0.8 = 10/60 * (4*5) / 0.8
    specs.maxPxDisplacementFrames = 30; % [px]
    specs.maxPxDisplacementKeyframes = 10^6; % [px] - relaxed!
    specs.meanGroundDistance = 5;
    specs.fracMaxSpeed = 0.8;
    
    testCombinations = 0;
end
    
%% start by running unit tests
% addpath('./tests')
% clc; run(testDesignDrone);

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

%% design!
[x,maxVel,maxFlightTime_minutes,cost] = designDrone(modules, specs, testCombinations);

