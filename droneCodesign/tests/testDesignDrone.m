classdef testDesignDrone < matlab.unittest.TestCase
    % unit tests for designDrone.m
    % you can run this by writing run(testDesignDrone) int he terminal
    
    methods(Test)
        %% test_xparse 
        function test_xparse(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
                        
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)]; 
            
            actSol = parsex(x, modules);
            expSol = ones(5,1); % we select the first design choice for each module
            
            testCase.verifyEqual(expSol,actSol)
        end
        
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
            meanGroundDistance = 3;
            [Aineq, bineq] = addFramerateConstraint([], [], modules, maxPxDisplacementFrames, meanGroundDistance);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % sum powers components - power battery < 0
            actSol = Aineq*x;
            
            g = 9.81; %[m/s^2]
            minDistance = 3; % min distance to obstacles
            f = 320; % focal length (px/m) % assume fixed for all cameras
            k = f / (maxPxDisplacementFrames * minDistance);
            rho = 1.2; % Air density [kg/m3],
            cd =  1.3; % the drag coefficient
            c = (0.5 * rho * cd)^2;
            
            % +4log(4T*g* 1e-3)-2log(A)-2log(m_b*g* 1e-3) - 4log(w) \leq log(c) - 4log(k) %% all masses in Kg
            T = 110; %[g]
            A = 0.29^2; %[m^2]
            m_b = 120; %[g]
            w = 30; % fps
            expSol = +4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-4*log(w); % = 3.5203
            expb = log(c) - 4*log(k);
            
            % +4log(4T*g* 1e-3)-2log(A)-2log(m_b*g*1e-3) - 4log(w) \leq log(c) - 4log(k)
            %=> 4log(w) > +4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3) -log(c) + 4log(k)
            maxv = exp( (+4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(c)) / 4); % 15.5329m/s
            minw = exp( (+4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(c)+4*log(k) ) / 4 ); % 248.5257 fps!!!
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            testCase.verifyEqual(expb,bineq)
            
            % TEST ESTIMATE SPEED FUNCTION
            effectiveMaxVel = estimateMaxForwardSpeed(modules,x); % = 5.218855216659
            upperBoundUsedInDesign = maxv; %  = 15.5328539200284
            gap = 10.313998; % our upper bound is not great (we underestimate weight a lot)
            testCase.verifyEqual(upperBoundUsedInDesign - gap,effectiveMaxVel,'AbsTol',1e-4)
            
            % TEST MORE REALISTIC VALUES
            T = 110; %[g]
            A = 0.29^2; %[m^2]
            m_b = 120; %[g]
            rho = 1.2; % Air density [kg/m3],
            cd =  1.3; % the drag coefficient
            c = (0.5 * rho * cd)^2;
            
            minDistance = 3;
            maxPxDisplacementFrames = 30;
            f = 320; % focal length (px/m) % assume fixed for all cameras
            k = f / (maxPxDisplacementFrames * minDistance);
            
            maxv1 = ( (1/(c*A^2)) * (4*T*g*1e-3)^2 * ((4*T*g*1e-3)^2/(m_b*g*1e-3)^2 - 1))^(1/4); % 15.5329m/s   
            maxv2 = exp( (+4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(c)) / 4); % other way to compute
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            minw = exp( (+4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(c)+4*log(k) ) / 4 ); %% more realistic = 55fps
        end 
        
        %% test_addFramerateConstraint_v2
        function test_addFramerateConstraint_v2(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            maxPxDisplacementFrames = 20;
            meanGroundDistance = 3;
            [Aineq, bineq] = addFramerateConstraint_v2([], [], modules, maxPxDisplacementFrames, meanGroundDistance);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % sum powers components - power battery < 0
            actSol = Aineq*x;
            
            g = 9.81; %[m/s^2]
            minDistance = 3; % min distance to obstacles
            f = 320; % focal length (px/m) % assume fixed for all cameras
            k = f / (maxPxDisplacementFrames * minDistance);
            rho = 1.2; % Air density [kg/m3],
            cd =  1.3; % the drag coefficient
            c = (0.5 * rho * cd)^2;
            
            T = 110; %[g]
            A = 0.29^2; %[m^2]
            m_m = 55; m_f = 750; m_c = 50; m_v = 38+50; m_b = 120; %[g]  
            w = 30; % fps
            expSol = +4*log(4*T*g*1e-3)-2*log(A)...
                -2*(log(4*m_m*g*1e-3)/5 + log(m_f*g*1e-3)/5 + log(m_c*g*1e-3)/5 + log(m_v*g*1e-3)/5 + log(m_b*g*1e-3)/5) ...
                -4*log(w); % = 3.5203
            expb = log(c) - 4*log(k) + 2*log(5);
            
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            testCase.verifyEqual(expb,bineq)
            
            % 4log(w) \geq 4log(k)+4log(4T)-log(c)-2log(A)-( SUM_i 2log(mi*g)/nrModules + 2log(nrModules) )
            maxv = exp( (+4*log(4*T*g*1e-3)-2*log(A)...
                -2*(log(4*m_m*g*1e-3)/5 + log(m_f*g*1e-3)/5 + log(m_c*g*1e-3)/5 + log(m_v*g*1e-3)/5 + log(m_b*g*1e-3)/5 + log(5)) ...
                -log(c)) / 4); % 6.1284m/s
            minw = exp( (+4*log(4*T*g*1e-3)-2*log(A)...
                -2*(log(4*m_m*g*1e-3)/5 + log(m_f*g*1e-3)/5 + log(m_c*g*1e-3)/5 + log(m_v*g*1e-3)/5 + log(m_b*g*1e-3)/5 + log(5)) ...
                -log(c)+4*log(k) ) / 4 ); % 32.6846 fps!!!
            
            % TEST ESTIMATE SPEED FUNCTION
            effectiveMaxVel = estimateMaxForwardSpeed(modules,x); % = 5.218855216659
            upperBoundUsedInDesign = maxv; %  = 6.1284
            gap = 0.9095; % good upper bound
            testCase.verifyEqual(upperBoundUsedInDesign - gap,effectiveMaxVel,'AbsTol',1e-4)
        end 
        
        %% test_addFramerateVIOConstraint
        function test_addFramerateVIOConstraint(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            [Aineq, bineq] = addFramerateVIOConstraint([], [], modules);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)]; 
            
            % fvio_frontend > fcamera => fcamera - fvio_frontend <= 0
            actSol = Aineq*x;
            expSol = 30 - 3.91; 
            
            testCase.verifyEqual(expSol,actSol)
            testCase.verifyEqual(0,bineq)
        end 
        
        %% test_addKeyframerateConstraint
        function test_addKeyframerateConstraint(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            maxPxDisplacementKeyframes = 100;
            meanGroundDistance = 3;
            [Aineq, bineq] = addKeyframerateConstraint([], [], modules, maxPxDisplacementKeyframes, meanGroundDistance);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % sum powers components - power battery < 0
            actSol = Aineq*x;
            
            g = 9.81; %[m/s^2]
            minDistance = 3; % min distance to obstacles
            f = 320; % focal length (px/m) % assume fixed for all cameras
            k = f / (maxPxDisplacementKeyframes * minDistance);
            rho = 1.2; % Air density [kg/m3],
            cd =  1.3; % the drag coefficient
            c = (0.5 * rho * cd)^2;
            
            % +4log(4T*g* 1e-3)-2log(A)-2log(m_b*g* 1e-3) - 4log(w) \leq log(c) - 4log(k) %% all masses in Kg
            T = 110; %[g]
            A = 0.29^2; %[m^2]
            m_b = 120; %[g]
            wvio = 2; % fps
            expSol = +4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-4*log(wvio); % = 3.5203
            expb = log(c) - 4*log(k);
            
            % +4log(4T*g* 1e-3)-2log(A)-2log(m_b*g*1e-3) - 4log(w) \leq log(c) - 4log(k)
            %=> 4log(w) > +4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3) -log(c) + 4log(k)
            maxv = exp( (+4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(c)) / 4); % 15.5329m/s 
            minw = exp( (+4*log(4*T*g*1e-3)-2*log(A)-2*log(m_b*g*1e-3)-log(c)+4*log(k) ) / 4 ); % 16.5684 fps
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            testCase.verifyEqual(expb,bineq)
        end
        
        %% test_addKeyframerateConstraint_v2
        function test_addKeyframerateConstraint_v2(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            maxPxDisplacementKeyframes = 100;
            meanGroundDistance = 3;
            [Aineq, bineq] = addKeyframerateConstraint_v2([], [], modules, maxPxDisplacementKeyframes, meanGroundDistance);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % sum powers components - power battery < 0
            actSol = Aineq*x;
            
            g = 9.81; %[m/s^2]
            minDistance = 3; % min distance to obstacles
            f = 320; % focal length (px/m) % assume fixed for all cameras
            k = f / (maxPxDisplacementKeyframes * minDistance);
            rho = 1.2; % Air density [kg/m3],
            cd =  1.3; % the drag coefficient
            c = (0.5 * rho * cd)^2;
            
            T = 110; %[g]
            A = 0.29^2; %[m^2]
            m_m = 55; m_f = 750; m_c = 50; m_v = 38+50; m_b = 120; %[g]  
            wvio = 2; % fps
            expSol = +4*log(4*T*g*1e-3)-2*log(A)...
                -2*(log(4*m_m*g*1e-3)/5 + log(m_f*g*1e-3)/5 + log(m_c*g*1e-3)/5 + log(m_v*g*1e-3)/5 + log(m_b*g*1e-3)/5) ......
                -4*log(wvio); % = 3.5203
            expb = log(c) - 4*log(k) + 2*log(5);
            
            maxv = exp( (+4*log(4*T*g*1e-3)-2*log(A)...
                -2*(log(4*m_m*g*1e-3)/5 + log(m_f*g*1e-3)/5 + log(m_c*g*1e-3)/5 + log(m_v*g*1e-3)/5 + log(m_b*g*1e-3)/5 + log(5)) ...
                -log(c)) / 4); % 6.1284m/s 
            minw = exp( (+4*log(4*T*g*1e-3)-2*log(A)...
                -2*(log(4*m_m*g*1e-3)/5 + log(m_f*g*1e-3)/5 + log(m_c*g*1e-3)/5 + log(m_v*g*1e-3)/5 + log(m_b*g*1e-3)/5 + log(5)) ...
                -log(c)+4*log(k) ) / 4 ); % 6.5369 fps
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            testCase.verifyEqual(expb,bineq)
        end

        %% test_addCostConstraint
        function test_addCostConstraint(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            maxBudget = 2500; % dollars
            [Aineq, bineq] = addCostConstraint([], [], modules, maxBudget);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)]; 
            
            % sum costs < maxBudget 
            actSol = Aineq*x;
            poundToDollarsRate = 1.28;
            expSol = 4*12.82 + 22.87 * poundToDollarsRate + 30 + 59 + 12.93 * poundToDollarsRate; % [note: 4 motors] 
            
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            testCase.verifyEqual(maxBudget,bineq,'AbsTol',1e-7)
        end 
        
        %% test_addEnduranceConstraint
        function test_addEnduranceConstraint(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            minFlightTime = 10*60; % 10min
            [Aineq, bineq] = addEnduranceConstraint([], [], modules, minFlightTime);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)]; 
            
            % -log(Battery Capacity)  + log(power motor)  < -log(minFlightTime) + log(0.8) + log(3600) 
            actSol = Aineq*x;
            expSol = -log(1.3)  + log(4*1); % [note: 4 motors] 
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            
            bExp = -log(minFlightTime) + log(0.8) + log(3600);
            testCase.verifyEqual(bExp,bineq,'AbsTol',1e-7)
            
            maxFlightTime = estimateFlightTime(modules,x); % better estimate of flight time that accounts for all currents drawn
            testCase.verifyEqual(15.1167 * 60,maxFlightTime,'AbsTol',1)
        end 
        
        %% test_addUniqueModuleConstraints
        function test_addUniqueModuleConstraints(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            [Aeq, beq] = addUniqueModuleConstraints([], [], modules);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % sum costs < maxBudget
            actSol = Aeq*x - beq;
            expSol = zeros(5,1); % constraint for each module
            
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
            
            % SECOND TEST
            x = [1; zeros(modules.nr_motors-2,1); 1; % not a feasible solution
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % sum costs < maxBudget
            actSol = Aeq*x - beq;
            expSol = [1; zeros(4,1)];
            
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
        end

        %% test_maxSpeedObjective
        function test_maxSpeedObjective(testCase)
            addpath('../moduleLibrary/');
            [modules] = loadModules();
            f = maxSpeedObjective(modules);
            
            x = [1; zeros(modules.nr_motors-1,1);
                1; zeros(modules.nr_frames-1,1);
                1; zeros(modules.nr_cameras-1,1);
                1; zeros(modules.nr_computerVIOs-1,1);
                1; zeros(modules.nr_batteries-1,1)];
            
            % 2log(A) - 2log(T)
            actSol = f*x;
            expSol = 2*log(0.29^2) - 2*log(4*110);%[note: 4 motors]
            
            testCase.verifyEqual(expSol,actSol,'AbsTol',1e-7)
        end
        
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