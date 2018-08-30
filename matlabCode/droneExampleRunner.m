% Codesign of an autonomous drone racing platform
% Author: Luca Carlone
% Date: 08/08/2018
clear all
close all
clc

%% test COST: system constraints
specs.maxBudget = 1000; % [$]
specs.minThrustRatio = 2; % []
specs.minFlightTime = 60 * 10; % [s] = X min
% batteryCapacity = 10/60 * AverageAmpDraw / 0.8 = 10/60 * (4*5) / 0.8
specs.maxPxDisplacementFrames = 30; % [px]
specs.maxPxDisplacementKeyframes = 10^6; % [px] - relaxed!
specs.meanGroundDistance = 5;
specs.fracMaxSpeed = 0.8;
 
budgets = [500:100:2000];
for i = 1:length(budgets)
    specs = setfield(specs,'maxBudget',budgets(i)); 
    [x,maxVel(i),maxFlightTime_minutes(i),cost(i)] = droneExample(specs);
    pause 
end

figure; title('maxVel'); plot(maxVel,'-b','linewidth',2); hold on; grid on
figure; title('maxFlightTime_minutes'); plot(maxFlightTime_minutes,'-k','linewidth',2); hold on; grid on
figure; title('cost'); plot(cost,'-r','linewidth',2); hold on; grid on

%% test flight time: system constraints
specs.maxBudget = 1000; % [$]
specs.minThrustRatio = 2; % []
specs.minFlightTime = 60 * 10; % [s] = X min
% batteryCapacity = 10/60 * AverageAmpDraw / 0.8 = 10/60 * (4*5) / 0.8
specs.maxPxDisplacementFrames = 30; % [px]
specs.maxPxDisplacementKeyframes = 10^6; % [px] - relaxed!
specs.meanGroundDistance = 5;
specs.fracMaxSpeed = 0.8;
 
minFlightTimes = [3:1:10]*60;
for i = 1:length(minFlightTimes)
    specs = setfield(specs,'minFlightTime',minFlightTimes(i)); 
    [x,maxVel(i),maxFlightTime_minutes(i),cost(i)] = droneExample(specs);
end

figure; title('maxVel vs minFlightTimes'); plot(maxVel,'-b','linewidth',2); hold on; grid on
figure; title('maxFlightTime_minutes vs minFlightTimes'); plot(maxFlightTime_minutes,'-k','linewidth',2); hold on; grid on
figure; title('cost vs minFlightTimes'); plot(cost,'-r','linewidth',2); hold on; grid on