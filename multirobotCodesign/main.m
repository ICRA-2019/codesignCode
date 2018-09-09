cnum = 2;
snum = 10;
mnum = 10;
bnum = 10;

% priorities = [[0.80 0.10 0.10]; [0.10 0.80 0.10]; [0.10 0.10 0.80]];
priorities = [[0.00 0.00 1.00]];
oradiuses = [1];
oweights = [10 20 40 60 80];
for ipriorities = 1:size(priorities,1)
    alpha = priorities(ipriorities,1);
    beta  = priorities(ipriorities,2);
    gamma = priorities(ipriorities,3);
    for ioradiuses = 1:numel(oradiuses)
        oradius = oradiuses(ioradiuses);
        for ioweights = 1:numel(oweights)
            oweight = oweights(ioweights);
            
            [robots, cweight, cradius, csize, scoverage, ...
             spower, sweight, ssize, mforce, mpower, mweight, ...
             msize, bpower, bweight, bsize] = generateproblem(oradius, oweight, cnum, snum, mnum, bnum);
            
            [x,fval,exitflag,output] = cplexformulation(oradius, ...
                                                        oweight, robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize, alpha, beta, gamma);
            
            printsolution(oradius, oweight, alpha, beta, gamma, x, fval, robots, cweight, ...
                          cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize);
            
        end
    end
end
