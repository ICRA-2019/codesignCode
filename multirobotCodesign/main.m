oradius = 0.1;
oweight = 5;
cnum = 10;
snum = 10;
mnum = 10;
bnum = 10;

ALPHA = 1.0;
BETA  = 1.0;
GAMMA = 0.1;

[robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize] = generateproblem(oradius, oweight, cnum, snum, mnum, bnum);

[x,fval,exitflag,output] = cplexformulation(oradius, oweight, robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize, ALPHA, BETA, GAMMA);

printsolution(x, robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize)

