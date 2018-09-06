function printsolution(x, robots, cweight, cradius, csize, scoverage, spower, sweight, ssize, mforce, mpower, mweight, msize, bpower, bweight, bsize)

if size(x,1) > 0

    ROBOT_SIZE = 1 + size(cweight,2) + size(sweight,2) + size(mweight,2) + size(bweight,2);


    for i = 0:(robots-1)
        if x(ROBOT_SIZE * i + 1) == 1
            fprintf("Robot %d\n", (i+1))
            chassis = x(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + 1 + size(cweight,2));
            fprintf("\tChassis: weight %f radius %f size %f\n", ...
            dot(chassis, cweight), ...
                dot(chassis, cradius), ...
                dot(chassis, csize))
            sensor = x(ROBOT_SIZE * i + 2 + size(cweight,2):ROBOT_SIZE * i + 1 + size(cweight,2) + size(sweight,2));
            fprintf("\tSensor: weight %f coverage %f size %f power %f\n", ...
            dot(sensor, sweight), ...
                dot(sensor, scoverage), ...
                dot(sensor, ssize), ...
                dot(sensor, spower))
            motor = x(ROBOT_SIZE * i + 2 + size(cweight,2) + size(sweight,2):ROBOT_SIZE * i + 1 + size(cweight,2) + size(sweight,2) + size(mweight,2));
            fprintf("\tMotor: force %f weight %f size %f power %f\n", ...
            dot(motor, mforce), ...
                dot(motor, mweight), ...
                dot(motor, msize), ...
                dot(motor, mpower))
            battery = x(ROBOT_SIZE * i + 2 + size(cweight,2) + size(sweight,2) + size(mweight,2):ROBOT_SIZE * i + 1 + size(cweight,2) + size(sweight,2) + size(mweight,2) + size(bweight,2));
            fprintf("\tBattery: power %f weight %f size %f\n", ...
            dot(battery, bpower), ...
                dot(battery, bweight), ...
                dot(battery, bsize))
            robot = x(ROBOT_SIZE * i + 2:ROBOT_SIZE * i + ROBOT_SIZE);
            fprintf("\tMargins:\n")
            fprintf("\t\tLift: %f\n", dot(robot,[-cweight -sweight (mforce-mweight) bweight]))
            fprintf("\t\tSize: %f\n", dot(robot,[csize -ssize -msize -bsize]))
            fprintf("\t\tPower: %f\n", dot(robot,[zeros(1,size(cweight,2)) -spower -mpower bpower]))
        end
    end
end