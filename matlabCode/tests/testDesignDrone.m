classdef testDesignDrone < matlab.unittest.TestCase
    % unit tests for designDrone.m
    % you can run this by writing run(testDesignDrone) int he terminal
    
    methods(Test)
        function test_A0(testCase)
            addpath('../moduleLibrary/');
            [Aineq, bineq] = addSizeConstraints([], [], modules);
            
            actSol = 1;
            expSol = 2;
            testCase.verifyEqual(actSol,expSol)
        end
        
    end %method
end %classdef