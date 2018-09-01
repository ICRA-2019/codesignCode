function testAllCombinations(modules, Aineq, bineq, Aeq, beq)

isFeasible = [];
vmaxs = [];
k = 1;
for i_m  = 1:modules.nr_motors
    for i_f  = 1:modules.nr_frames
        for i_cam  = 1:modules.nr_cameras
            for i_vio  = 1:modules.nr_computerVIOs
                for i_bat  = 1:modules.nr_batteries
                    x_motor = zeros(modules.nr_motors,1); x_motor(i_m)=1;
                    x_frame = zeros(modules.nr_frames,1); x_frame(i_f)=1;
                    x_cam = zeros(modules.nr_cameras,1); x_cam(i_cam)=1;
                    x_vio = zeros(modules.nr_computerVIOs,1); x_vio(i_vio)=1;
                    x_bat = zeros(modules.nr_batteries,1); x_bat(i_bat)=1;
                    xtest = [x_motor; x_frame; x_cam; x_vio; x_bat];
                    
                    % sanity check
                    if norm(Aeq*xtest - beq) > 1e-5
                        error('combinations are wrong')
                    end
                    
                    % check feasibility
                    if(sum(Aineq*xtest <= bineq) == size(Aineq,1))
                        isFeasible(k) = 1;
                    else
                        isFeasible(k) = 0;
                    end
                    % check objective
                    vmax_vec(k) = estimateMaxForwardSpeed(modules,xtest);
                    cost_vec(k) = estimateCost(modules,xtest);
                    [~,mft_minutes_vec(k)] = estimateFlightTime(modules,xtest);
                    k = k+1;
                end
            end
        end
    end
end

%% plot vmax
[vmax_vec,ind] = sort(vmax_vec);
isFeasible_sortvmax = isFeasible(ind);
figure; hold on; grid on 
ylabel('max speed [m/s]')
xlabel('design')
plot(vmax_vec,'-k', 'linewidth',1);
indNotFeasible = find(isFeasible_sortvmax == 0);
plot(indNotFeasible,vmax_vec(indNotFeasible),'xr', 'markersize',2);
indFeasible = find(isFeasible_sortvmax == 1);
plot(indFeasible,vmax_vec(indFeasible),'*g', 'markersize',15);
dim = 24;
set(gca,'FontSize',dim) %
saveas(gca,'~/Desktop/maxspeed.eps','epsc')

%% plot cost
[cost_vec,ind] = sort(cost_vec);
isFeasible_sortcost = isFeasible(ind);
figure; hold on; grid on
ylabel('cost [$]')
xlabel('design')
plot(cost_vec,'-k', 'linewidth',1);
indNotFeasible = find(isFeasible_sortcost == 0);
plot(indNotFeasible,cost_vec(indNotFeasible),'xr', 'markersize',2);
indFeasible = find(isFeasible_sortcost == 1);
plot(indFeasible,cost_vec(indFeasible),'*g', 'markersize',15);
dim = 24;
set(gca,'FontSize',dim) %
saveas(gca,'~/Desktop/cost.eps','epsc')

%% plot flight time
[mft_minutes_vec,ind] = sort(mft_minutes_vec);
isFeasible_sortmft = isFeasible(ind);
figure; hold on; 
title('mft minutes')
plot(mft_minutes_vec,'-k', 'linewidth',1);
indNotFeasible = find(isFeasible_sortmft == 0);
plot(indNotFeasible,mft_minutes_vec(indNotFeasible),'xr', 'markersize',2);
indFeasible = find(isFeasible_sortmft == 1);
plot(indFeasible,mft_minutes_vec(indFeasible),'*g', 'markersize',10);

