function computerVIOs = getComputerVIOTable()

% 1:size(m)  2:weight with cooler(g) 3:voltage(V)  4:current(A)  5:cost($) 6:Front-end Throughput(s) 7:back-end Throughput(Hz)
% TX2 voltage: +9V - +14V DC Nominal 

% laptop current: zero since it is self powered by its own battery
computerVIOs_tranpose = ...     
[0.083           38+50                    5             4           59              3.91                       2  % odroid: https://www.hardkernel.com/main/products/prdt_info.php
 0.025             55                     5             2.4         35                2                        1  % rapsberry pi: https://www.adafruit.com/product/3055
 0.086             41                     0             0           1900             15                        8  % laptop: https://www.apple.com/macbook-pro/specs/
 0.09             144                     11            3.6          500              12                       6  % TX2: http://www.connecttech.com/pdf/ASG003.pdf
 ]; 
% current for TX2 is computed as 40/voltage as in https://developer.download.nvidia.com/assets/embedded/secure/jetson/TX2/docs/NVIDIA_Jetson_TX1_and_TX2_Voltage_and_Current_Monitor_Configuration.pdf?jDztrs19FkudzJcAefUJ3SQNRNF77yq9d2SaAlXKW49QMpV7_HiRsjXtpRnD3UW_zIsqztD4x0d3zGbY2Kt3lJr15RckTKHGOkmuAsXvzUt8nb2gy77n9zjk4EMvys8wzV-blLOr81zJiWC34ArQFXyFMC891ccqLENc-o9Yu7FG_C_2KOKVxvGBmQzbslR1qywvOcpQn6Tspn_7n-4sM_mUWhC4umKyC7pfD6U
computerVIOs = computerVIOs_tranpose';