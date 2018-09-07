cnum = 10;
snum = 10;
mnum = 10;
bnum = 10;

priorities = [0.25 0.5 0.75];
oradiuses = [0.5 1 2];
oweights = [1 2 8];
for ialpha = 1:numel(priorities)
    alpha = priorities(ialpha);
    for ibeta = 1:numel(priorities)
        beta = priorities(ibeta);
        for igamma = 1:numel(priorities)
            gamma = priorities(igamma);
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
    end
end

