function motors = getMotorTable()

%% Emax MT2213 935Kv https://www.unmannedtechshop.co.uk/brushless-motor-emax-mt2213-935kv/
% size = diameter
motors_tranpose = ...
% 1:size(m)  2:weight(g) 3:voltage(V)  4:current(A)  5:cost($)  6:thrust(g)     
[0.025           55          11             1         12.82        110 % EMAX8045
 0.025           55          11             2         12.82        200
 0.025           55          11             3         12.82        270
 0.025           55          11             4         12.82        330
 0.025           55          11             5         12.82        390
 0.025           55          11             6         12.82        440
 0.025           55          11             7.1       12.82        490
 %
 0.025           55          11             1         12.82        130 % EMAX1045
 0.025           55          11             2         12.82        220
 0.025           55          11             3         12.82        290
 0.025           55          11             4         12.82        370
 0.025           55          11             5         12.82        430
 0.025           55          11             6         12.82        480
 0.025           55          11             7         12.82        540
 0.025           55          11             8         12.82        590
 0.025           55          11             9         12.82        640
 0.025           55          11             9.6       12.82        670
 ]; 

%% https://alofthobbies.com/power/motors/emax-cf-series.html
%% https://www.emaxmodel.com/emax-rs2205-racespec-motor.html
%% DYS D2822 2282 (https://www.banggood.com/DYS-D2822-2282-1100KV-1450KV-1800KV-2600KV-Brushess-Motor-p-986145.html?cur_warehouse=CN)
    
motors = motors_tranpose';