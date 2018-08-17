classdef testDesignDrone < matlab.unittest.TestCase
    % unit tests for designDrone.m
    % you can run this by writing run(testDesignDrone) int he terminal
    
    methods(Test)
        %% test_addSizeConstraints 
        function test_addSizeConstraints(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            [Aineq, bineq] = addSizeConstraints([], [], modules);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)]; 
            
            actSol = Aineq*x;
            expSol = [0.025 - 0.290;
                0.03 - 0.290;
                0.083 - 0.290;
                0.071 - 0.290];
            
            testCase.verifyEqual(expSol,actSol)
            testCase.verifyEqual(zeros(4,1),bineq)
        end
        
        %% test_addThrustConstraint 
        function test_addThrustConstraint(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            minThrustRatio = 1.3;
            [Aineq, bineq] = addThrustConstraint([], [], modules, minThrustRatio);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)]; 
            
            % minThrustRatio * sum weight components - Motor_trust X nrMotors < 0
            actSol = Aineq*x;
            expSol = minThrustRatio * (4*55 + 750 + 50 + 38+50 + 120) - 4*110; % = 1.1564e+03
            
            testCase.verifyEqual(actSol,expSol)
            testCase.verifyEqual(0,bineq)
            
            % ===== SECOND TEST =========
            motorChoice = 14;
            xmotor = zeros(modules.nr_motors,1); 
            xmotor(motorChoice) = 1;
            x = [xmotor;
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % minThrustRatio * sum weight components - Motor_trust X nrMotors < 0
            actSol = Aineq*x;
            expSol = minThrustRatio * (4*55 + 750 + 50 + (38+50) + 120) - 4*540; % = -5.636e+02
            
            testCase.verifyEqual(actSol,expSol,'AbsTol',1e-7)
        end
        
        %% test_addPowerConstraint
        function test_addPowerConstraint(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            [Aineq, bineq] = addPowerConstraint([], [], modules);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)]; 
            
            % sum powers components - power battery < 0
            actSol = Aineq*x;
            expSol = (4*11*1+3*0.3+5*4)-11.1*58.5; % = -584.45 (note: 4 motors)
            
            testCase.verifyEqual(expSol,actSol)
            testCase.verifyEqual(0,bineq)
        end       

        %% test_addFramerateConstraint
        function test_addFramerateConstraint(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            maxPxDisplacementFrames = 20;
            [Aineq, bineq] = addFramerateConstraint([], [], modules, maxPxDisplacementFrames);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % sum powers components - power battery < 0
            actSol = Aineq*x;
            
            g = 9.81; %[m/s^2]
            minDistance = 1; % min distance to obstacles
            f = 320; % focal length (px/m) % assume fixed for all cameras
            k = f / (maxPxDisplacementFrames * minDistance);
            rho = 1.2; % Air density [kg/m3],
            cd =  1.3; % the drag coefficient
            c = (0.5 * rho * cd)^2;
            
            % +4log(4T*g* 1e-3)-2log(A)-2log(m_b*g* 1e-3) - log(w) \leq log(c) - log(k) %% all masses in Kg
            T = 110; %[g]
            A = 0.055^2; %[m^2]
            m_b = 120; %[g]
            w = 30; % fps
            expSol = +4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(w) % = 13.7239
            actSol
            expb = log(c) - log(k);
            
            % +4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(w) < log(c) - log(k)
            %=> log(w) > +4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3) -log(c) + log(k)
            minw = exp(+4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3) -log(c) + log(k))
            
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            testCase.verifyEqual(expb,bineq)
        end 
        % %% Implicit constraint: minimum frame-rate
        % [Aineq, bineq] = addFramerateVIOConstraint(Aineq, bineq, modules);
        %
        % %% Implicit constraint: minimum keyframe-rate
        % [Aineq, bineq] = addKeyframerateConstraint(Aineq, bineq, modules, specs.maxPxDisplacementKeyframes);
        %
        % %% system constraint: maximum cost
        % [Aineq, bineq] = addCostConstraint(Aineq, bineq, modules, specs.maxBudget);
        %
        % %% system constraint: minimum flight time
        % [Aineq, bineq] = addEnduranceConstraint(Aineq, bineq, modules, specs.minFlightTime);
        %
        % %% design constraint: pick one for each module
        % [Aeq, beq] = addUniqueModuleConstraints(Aeq, beq, modules);
        %
        % %% system objective: maximum speed
        % f = maxSpeedObjective(modules);
        
    end %method
end %classdef

function [modules] = loadModules()
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
end