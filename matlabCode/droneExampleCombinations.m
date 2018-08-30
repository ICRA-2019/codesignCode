% Codesign of an autonomous drone racing platform
% Author: Luca Carlone
% Date: 08/08/2018
clear all
close all
clc

specs.maxBudget = 1000; % [$]
specs.minThrustRatio = 2; % []
specs.minFlightTime = 60 * 10; % [s] = X min
specs.maxPxDisplacementFrames = 30; % [px]
specs.maxPxDisplacementKeyframes = 10^6; % [px] - relaxed!
specs.meanGroundDistance = 5;
specs.fracMaxSpeed = 0.8;
 
testCombinations = 0;
droneExample(specs,testCombinations); 