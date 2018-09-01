% Example of use of IBM cplex, called from Matlab
% Author: Luca Carlone
% Date: 10/16/2017

clear all
close all
clc

addpath('./libCPLEX')

%% Problem description:
% min_x c' x
% st    Ax <= b

%% Generate data in Matlab
n = 10; % size of x
m = 6;
c = randn(n,1);
A = rand(m,n);
b = rand(m,1);

%% Print to file, to be used for CPLEX
fileName = fopen('data_example_cplex.dat','w');
%
writeScalarOPL(fileName, n, 'n', 'int');
writeScalarOPL(fileName, m, 'm', 'int');
%
writeVectorOPL(fileName, c, 'c');
writeVectorOPL(fileName, b, 'b');
%
writeMatrixOPL(fileName, A, 'A');
%
fclose(fileName);

%% RUN:
modfile = 'model_example_cplex.mod';
datfile = 'data_example_cplex.dat';
disp('- calling cplex to solve MILP')
[optTime] = runCPLEX(modfile,datfile)

%% Read result from cplex output file:
x = dlmread('output-x.txt'); x = x(:);

%% Print x:
disp(x)











