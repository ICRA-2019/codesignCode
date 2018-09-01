function cameras = getCameraTable()

% for simplicity we use this: Free Shipping Raspberry Pi CSI Camera Module
% (https://www.digikey.com/products/en?mpart=913-2664&v=1690)
% and we manually alter framerate (and change power accordingly) and
% guess weight
% power: https://www.sony-semicon.co.jp/products_en/new_pro/april_2014/imx219_e.html
% 1:size(m)  2:weight      3:voltage(V)  4:current(A)  5:cost($)       6:framerate
cameras_tranpose = ...     
[0.03              50         3             0.3            30               30 
0.03               50         3             0.3            60               60 
0.03               50         3             0.3           100               100 
0.03               50         3             0.3           200               200 
 ]; 

cameras = cameras_tranpose';