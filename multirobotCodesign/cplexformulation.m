% Codesign of a swarm of robots performing collective transport
% Author: Carlo Pinciroli
% Date: 05/09/2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State matrix
% - Each column is a robot (R)
% - Each row is a specific aspect of the robot
%   - Row 1: whether this robot slot is selected (1)
%   - Row chassis: selected chassis              (C)
%   - Row sensing: selected sensing device       (S)
%   - Row motor: selected motor                  (M)
%   - Row battery: selected battery              (B)
% The final size of the matrix is then (R x (1+C+S+M+B))
%
% The state vector is then flattened so it's formed by R blocks, each
% with (1+C+S+M+B) elements

function [x,fval,exitflag,output] = cplexformulation(oradius, oweight, robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize, ALPHA, BETA, GAMMA)

cnum = size(cweight,2);
snum = size(sweight,2);
mnum = size(mweight,2);
bnum = size(bweight,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performance measure
% f = ALPHA * force + BETA * sensing - GAMMA * number of robots
fforce   = repmat([  zeros(1,1+cnum+snum) mforce    zeros(1,bnum)     ], 1, robots);
fsensing = repmat([  zeros(1,1+cnum)      scoverage zeros(1,mnum+bnum)], 1, robots);
frobots  = repmat([1 zeros(1,cnum+snum+mnum+bnum)                     ], 1, robots);
f = -(ALPHA * fforce + BETA * fsensing - GAMMA * frobots);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
ROBOT_SIZE = 1 + cnum + snum + mnum + bnum;
TOTAL_SIZE = robots * ROBOT_SIZE;
Aineq = [];
bineq = [];
Aeq   = [];
beq   = [];



%%%%%%%%%%%%%%%%%%%%
% Basic constraints

%%%%%%%%%%
% 1. If a slot is activated, the robot has one chassis
for i = 0:(robots-1)
    c1 = zeros(1, TOTAL_SIZE);
    c1(ROBOT_SIZE * i + 1) = -1;
    c1(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + cnum + 1) = ones(1, cnum);
    Aeq = [Aeq; c1];
    beq = [beq; 0];
end

%%%%%%%%%%
% 2. If a slot is activated, the robot has one motor
for i = 0:(robots-1)
    c2 = zeros(1, TOTAL_SIZE);
    c2(ROBOT_SIZE * i + 1) = -1;
    c2(ROBOT_SIZE * i + 2 + cnum + snum:ROBOT_SIZE * i + 1 + cnum + snum + mnum) = ones(1, mnum);
    Aeq = [Aeq; c2];
    beq = [beq; 0];
end

%%%%%%%%%%
% 3. If a slot is activated, the robot has one battery
for i = 0:(robots-1)
    c3 = zeros(1, TOTAL_SIZE);
    c3(ROBOT_SIZE * i + 1) = -1;
    c3(ROBOT_SIZE * i + 2 + cnum + snum + mnum:ROBOT_SIZE * i + 1 + cnum + snum + mnum + bnum) = ones(1, bnum);
    Aeq = [Aeq; c3];
    beq = [beq; 0];
end

%%%%%%%%%%
% 4. If a slot is activated, the robot has at most one sensor
for i = 0:(robots-1)
    c4 = zeros(1, TOTAL_SIZE);
    c4(ROBOT_SIZE * i + 2 + cnum:ROBOT_SIZE * i + 1 + cnum + snum) = ones(1, snum);
    c4(ROBOT_SIZE * i + 1) = -1;
    Aineq = [Aineq; c4];
    bineq = [bineq; 0];
end

%%%%%%%%%%%%%%%%%%%%
% Motor/weight constraints

%%%%%%%%%%
% 5. The weight of a robot is lower than the force it can exert
c5lift = [cweight sweight (mweight-mforce) bweight];
for i = 0:(robots-1)
    c5 = zeros(1, TOTAL_SIZE);
    c5(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + 2 + size(c5lift,2) - 1) = c5lift;
    Aineq = [Aineq; c5];
    bineq = [bineq; 0];
end

%%%%%%%%%%%%%%%%%%%%
% 6. The total force exerted is enough to lift the robots and the object
c6 = repmat([0 cweight sweight (mweight-mforce) bweight], 1, robots);
Aineq = [Aineq; c6];
bineq = [bineq; -oweight];



%%%%%%%%%%%%%%%%%%%%
% Power consumption constraints

%%%%%%%%%%
% 7. The power consumption of a robot is lower than the power given by the battery
c7pow = [spower mpower -bpower];
for i = 0:(robots-1)
    c7 = zeros(1, TOTAL_SIZE);
    c7(ROBOT_SIZE * i + 2 + cnum:ROBOT_SIZE * i + cnum + size(c7pow,2) + 1) = c7pow;
    Aineq = [Aineq; c7];
    bineq = [bineq; 0];
end



%%%%%%%%%%%%%%%%%%%%
% Size constraints

%%%%%%%%%%
% 8. The total size of the components of a robot is lower than the size of the chassis
c8size = [-csize ssize msize bsize];
for i = 0:(robots-1)
    c8 = zeros(1, TOTAL_SIZE);
    c8(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + size(c8size,2) + 1) = c8size;
    Aineq = [Aineq; c8];
    bineq = [bineq; 0];
end

%%%%%%%%%%
% 9. The total size of the robots is lower than the circumference
% of the object
c9 = repmat([0 2.0*cradius zeros(1, snum+mnum+bnum)], 1, robots);
Aineq = [Aineq; c9];
bineq = [bineq; oradius];



%%%%%%%%%%%%%%%%%%%%
% Sensor constraints

%%%%%%%%%%
% 10. At least 50% of the area is covered
c10 = repmat([zeros(1, 1+cnum) -scoverage zeros(1, mnum+bnum)], 1, robots);
Aineq = [Aineq; c10];
bineq = [bineq; -50];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform optimization
[x,fval,exitflag,output] = cplexbilp(f, Aineq, bineq, Aeq, beq);
