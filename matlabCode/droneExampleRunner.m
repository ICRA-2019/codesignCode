% Codesign of an autonomous drone racing platform
% Author: Luca Carlone
% Date: 08/08/2018
clear all
close all
clc

% test COST: system constraints
specs.maxBudget = 1000; % [$]
specs.minThrustRatio = 2; % []
specs.minFlightTime = 60 * 10; % [s] = X min
% batteryCapacity = 10/60 * AverageAmpDraw / 0.8 = 10/60 * (4*5) / 0.8
specs.maxPxDisplacementFrames = 30; % [px]
specs.maxPxDisplacementKeyframes = 10^6; % [px] - relaxed!
specs.meanGroundDistance = 5;
specs.fracMaxSpeed = 0.8;
 
budgets = [500:50:5000];
for i = 1:length(budgets)
    specs = setfield(specs,'maxBudget',budgets(i)); 
    [x,maxVel(i),maxFlightTime_minutes(i),cost(i)] = droneExample(specs); 
end

figure; title('maxVel'); hold on;  plot(budgets,maxVel,'-b','linewidth',2); grid on
figure; title('maxFlightTime_minutes'); hold on;  plot(budgets,maxFlightTime_minutes,'-k','linewidth',2); hold on; grid on
figure; title('cost'); hold on; plot(budgets,cost,'-r','linewidth',2); hold on; grid on

%% test flight time: system constraints
clear all
specs.maxBudget = 1000; % [$]
specs.minThrustRatio = 2; % []
specs.minFlightTime = 60 * 10; % [s] = X min
% batteryCapacity = 10/60 * AverageAmpDraw / 0.8 = 10/60 * (4*5) / 0.8
specs.maxPxDisplacementFrames = 30; % [px]
specs.maxPxDisplacementKeyframes = 10^6; % [px] - relaxed!
specs.meanGroundDistance = 5;
specs.fracMaxSpeed = 0.8;
 
minFlightTimes = [3:0.5:12]*60;
for i = 1:length(minFlightTimes)
    specs = setfield(specs,'minFlightTime',minFlightTimes(i)); 
    [x,maxVel(i),maxFlightTime_minutes(i),cost(i)] = droneExample(specs);
end

figure; title('maxVel vs minFlightTimes'); hold on; plot(minFlightTimes/60,maxVel,'-b','linewidth',2);  grid on
figure; title('maxFlightTime_minutes vs minFlightTimes'); hold on; plot(minFlightTimes/60,maxFlightTime_minutes,'-k','linewidth',2); hold on; grid on
figure; title('cost vs minFlightTimes'); hold on; plot(minFlightTimes/60,cost,'-r','linewidth',2); hold on; grid on