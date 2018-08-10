function batteries = getBatteryTable()

% https://www.unmannedtechshop.co.uk/Lipo-Batteries/?_bc_fsnf=1&Voltage=11.1V
% size = longest side
% current = max continuous discharge

% 1:size(m)  2:weight(g) 3:voltage(V)  4:current(A)    5:cost(pound)  6:dischargeRate(C)   7:capacity(A/h) 
batteries_tranpose = ...  
[0.071           120          11.1           58.5        12.93         90                1.3 % Tattu 1300mAh 11.1V 45C 3S1P LiPo Battery
 0.071           122          11.1           97.5        12.82        150                1.3 % Tattu 1300mAh 11.1V 75C 3S1P LiPo Battery Pack
 0.059            85          11.1           63.75       11.73         75                0.85 % Tattu 850mAh 11.1V 75C 3S1P Lipo Battery Pack
 0.105           183          11.1            55         17.99         50                2.2 % Gens Ace 2200mAh 11.1V 25C 3S1P Lipo Battery Pack with XT60 Plug
 0.092           156          11.1            81         18.83         45                1.8 % Tattu 1800mAh 11.1V 3S 45C LiPo Battery Pack
 0.137           331          11.1            51         39.99         10                5.1 % Tattu 5100mAh 11.1V 3S 10C Battery Pack
 %
 0.072           135          11.1          116.25       16.89         75                1.5 % TATTU 1550mAh 11.1V 75C 3S1P Lipo Battery Pack
 0.072           135          11.1           69.75       14.95         45               0.85 % TATTU 1550mAh 11.1V 45C 3S1P Lipo Battery Pack
 0.072            96          11.1            25         7.95          25                 1  % Gens ace 1000mAh 11.1V 25C 3S1P Lipo Battery Pack
 0.072           130          11.1          78.75       12.99         75                 1  % Tattu 1050mAh 11.1V 75C 3S1P Lipo Battery Pack
 0.058            72          11.1            32        10.99          40                0.8  % Gens ace 800mAh 11.1V 40C 3S1P Lipo Battery Pack
 
 0.106           315          11.1            52        39.50          20                5.2  % GensAce 5200mAh 11.1V 10/20C 3S2P Lipo Battery Pack
 ]; 

cost_col = 5;
batteries_tranpose(:,cost_col) = batteries_tranpose(:,cost_col) * 1.28; % convert to dollars

batteries = batteries_tranpose';