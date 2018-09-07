function printsolution(oradius, oweight, alpha, beta, gamma, x, fval, ...
                       robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize)

fname = sprintf('results_%.2f_%.2f_%.2f_%.2f_%.2f.dat', oradius, oweight, alpha, beta, gamma);
fid = fopen(fname, 'w');

fprintf('%s\n', fname);

fprintf(fid, "Object Radius %f\n", oradius);
fprintf(fid, "Object Weight %f\n", oweight);
fprintf(fid, "Alpha %f\n", alpha);
fprintf(fid, "Beta %f\n", beta);
fprintf(fid, "Gamma %f\n", gamma);

if size(x,1) > 0
    fprintf(fid, "Performance %f\n", fval);
    ROBOT_SIZE = 1 + size(cweight,2) + size(sweight,2) + size(mweight,2) + size(bweight,2);
    totlift = 0.0;
    totcoverage = 0.0;
    for i = 0:(robots-1)
        if x(ROBOT_SIZE * i + 1) == 1
            fprintf(fid, "Robot %d\n", (i+1));
            chassis = x(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + 1 + size(cweight,2));
            fprintf(fid, "\tChassis: weight %f radius %f size %f\n", ...
            dot(chassis, cweight), ...
                dot(chassis, cradius), ...
                dot(chassis, csize));
            sensor = x(ROBOT_SIZE * i + 2 + size(cweight,2):ROBOT_SIZE * i + 1 + size(cweight,2) + size(sweight,2));
            fprintf(fid, "\tSensor: weight %f coverage %f size %f power %f\n", ...
            dot(sensor, sweight), ...
                dot(sensor, scoverage), ...
                dot(sensor, ssize), ...
                dot(sensor, spower));
            motor = x(ROBOT_SIZE * i + 2 + size(cweight,2) + size(sweight,2):ROBOT_SIZE * i + 1 + size(cweight,2) + size(sweight,2) + size(mweight,2));
            fprintf(fid, "\tMotor: force %f weight %f size %f power %f\n", ...
            dot(motor, mforce), ...
                dot(motor, mweight), ...
                dot(motor, msize), ...
                dot(motor, mpower));
            battery = x(ROBOT_SIZE * i + 2 + size(cweight,2) + size(sweight,2) + size(mweight,2):ROBOT_SIZE * i + 1 + size(cweight,2) + size(sweight,2) + size(mweight,2) + size(bweight,2));
            fprintf(fid, "\tBattery: power %f weight %f size %f\n", ...
            dot(battery, bpower), ...
                dot(battery, bweight), ...
                dot(battery, bsize));
            robot = x(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + ROBOT_SIZE);
            fprintf(fid, "\tMargins:\n");
            lift = dot(robot,[-cweight -sweight (mforce-mweight) bweight]);
            fprintf(fid, "\t\tLift: %f\n", lift);
            fprintf(fid, "\t\tSize: %f\n", dot(robot,[csize -ssize -msize -bsize]));
            fprintf(fid, "\t\tPower: %f\n", dot(robot,[zeros(1,size(cweight,2)) -spower -mpower bpower]));
            totlift = totlift + lift;
            totcoverage = totcoverage + dot(sensor, scoverage);
        end
    end
    fprintf(fid, "Overall:\n");
    fprintf(fid, "\t%d slots used out of %d\n", dot(repmat([1 zeros(1,size(cweight,2)+size(sweight,2)+size(mweight,2)+size(bweight,2))], 1, robots), x), robots);
    fprintf(fid, "\tLift: %f\n", (totlift - oweight));
    fprintf(fid, "\tCoverage: %f\n", totcoverage);
else
    fprintf(fid, "No solutions found.\n");
end
