function [optTime] = runCPLEX(modfile,datfile)

timeCPLEX = tic;
%% Preview version
%mypath = "/Users/Luca/Applications/IBM/ILOG/CPLEX_Studio1271";
system(sprintf('export LD_LIBRARY_PATH=/opt/ibm/ILOG/CPLEX_Studio1261/opl/bin/x86-64_linux/; /opt/ibm/ILOG/CPLEX_Studio1261/opl/bin/x86-64_linux/oplrun %s %s', modfile,datfile));

%% Full version under academic initiative (32bit)
% system(sprintf('export LD_LIBRARY_PATH=/opt/ibm/ILOG/CPLEX_Studio126/opl/bin/x86_linux/; /opt/ibm/ILOG/CPLEX_Studio126/opl/bin/x86_linux/oplrun %s %s', modfile,datfile));

%% Full version under academic initiative
% system(sprintf('export LD_LIBRARY_PATH=/opt/ibm/ILOG/CPLEX_Studio126/opl/bin/x86-64_linux/; /opt/ibm/ILOG/CPLEX_Studio126/opl/bin/x86-64_linux/oplrun %s %s', modfile,datfile));

optTime = toc(timeCPLEX);