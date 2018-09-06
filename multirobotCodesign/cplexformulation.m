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
f = ALPHA * fforce + BETA * fsensing - GAMMA * frobots;



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
% 0. There has to be at least a robot
% $$$ c0 = repmat([-1 zeros(1,cnum + snum + mnum + bnum)], 1, robots);
% $$$ Aineq = [Aineq; c0];
% $$$ bineq = [-1];

%%%%%%%%%%
% 1. A robot can have one chassis at most
for i = 0:(robots-1)
    c1 = zeros(1, TOTAL_SIZE);
    c1(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + cnum + 1) = ones(1, cnum);
    Aineq = [Aineq; c1];
    bineq = [bineq; 1];
end

%%%%%%%%%%
% 2. If a robot has a chassis, its slot is activated
for i = 0:(robots-1)
    c2 = zeros(1, TOTAL_SIZE);
    c2(ROBOT_SIZE * i + 1) = -1;
    c2(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + cnum + 1) = ones(1, cnum);
    Aeq = [Aeq; c2];
    beq = [beq; 0];
end

%%%%%%%%%%
% 3. If a robot has a chassis, it has a motor
for i = 0:(robots-1)
    c3 = zeros(1, TOTAL_SIZE);
    c3(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + cnum + 1) = ones(1, cnum);
    c3(ROBOT_SIZE * i + 2 + cnum + snum:ROBOT_SIZE * i + 1 + cnum + snum + mnum) = -ones(1, mnum);
    Aeq = [Aeq; c3];
    beq = [beq; 0];
end

%%%%%%%%%%
% 4. If a robot has a chassis, it has a battery
for i = 0:(robots-1)
    c4 = zeros(1, TOTAL_SIZE);
    c4(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + cnum + 1) = ones(1, cnum);
    c4(ROBOT_SIZE * i + 2 + cnum + snum + mnum:ROBOT_SIZE * i + 1 + cnum + snum + mnum + bnum) = -ones(1, bnum);
    Aeq = [Aeq; c4];
    beq = [beq; 0];
end

%%%%%%%%%%
% 5. If a robot has a chassis, it can have a sensor at most
for i = 0:(robots-1)
    c5 = zeros(1, TOTAL_SIZE);
    c5(ROBOT_SIZE * i + 2 + cnum:ROBOT_SIZE * i + 1 + cnum + snum) = ones(1, snum);
    c5(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + cnum + 1) = -ones(1, cnum);
    Aineq = [Aineq; c5];
    bineq = [bineq; 0];
end



%%%%%%%%%%%%%%%%%%%%
% Motor/weight constraints

%%%%%%%%%%
% 6. The weight of a robot is lower than the force it can exert
c6lift = [cweight sweight (mweight-mforce) bweight];
for i = 0:(robots-1)
    c6 = zeros(1, TOTAL_SIZE);
    c6(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + 2 + size(c6lift,2) - 1) = c6lift;
    Aineq = [Aineq; c6];
    bineq = [bineq; 0];
end

%%%%%%%%%%%%%%%%%%%%
% 7. The total force exerted is enough to lift the robots and the object
c7 = repmat([0 cweight sweight (mweight-mforce) bweight], 1, robots);
Aineq = [Aineq; c7];
bineq = [bineq; -oweight];



%%%%%%%%%%%%%%%%%%%%
% Power consumption constraints

%%%%%%%%%%
% 8. The power consumption of a robot is lower than the power given by the battery
c8pow = [spower mpower -bpower];
for i = 0:(robots-1)
    c8 = zeros(1, TOTAL_SIZE);
    c8(ROBOT_SIZE * i + 2 + cnum:ROBOT_SIZE * i + cnum + size(c8pow,2) + 1) = c8pow;
    Aineq = [Aineq; c8];
    bineq = [bineq; 0];
end



%%%%%%%%%%%%%%%%%%%%
% Size constraints

%%%%%%%%%%
% 9. The total size of the components of a robot is lower than the size of the chassis
c9size = [-csize ssize msize bsize];
for i = 0:(robots-1)
    c9 = zeros(1, TOTAL_SIZE);
    c9(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + size(c9size,2) + 1) = c9size;
    Aineq = [Aineq; c9];
    bineq = [bineq; 0];
end



%%%%%%%%%%%%%%%%%%%%
% Sensor constraints

%%%%%%%%%%
% 10. At least 50% of the area is covered
c10 = repmat([zeros(1, 1+cnum) -scoverage zeros(1, mnum+bnum)], 1, robots);
Aineq = [Aineq; c10];
bineq = [bineq; -50];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform optimization
cplexoptimset()
[x,fval,exitflag,output] = cplexbilp(f, Aineq, bineq, Aeq, beq);
