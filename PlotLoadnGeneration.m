% Plots generation throughout day against load demand
% Forms of generation
[time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
[~, solarPower] = CreateSolarArrays();
[~, windPowerOff, windPowerOn] = CreateWindArrays();
windPower = windPowerOff + windPowerOn;
geoPower = ones(365,288) * 15;
geoPower(:,109:180) = zeros(365, 72);
totalGeneration = solarPower + windPower + geoPower;

day = 45;

% Total generation
figure(22)
clf
plot(time(day,:),data(day,:))
hold on
plot(time(day,:),totalGeneration(day,:))
hold off
title(strcat("Load and Generation for ", datestr(time(day,1),'mm/dd/yy')))
xlabel("Time")
ylabel("Power [MW]")

% Surplus/Defeceit curve
netEnergy = (data - totalGeneration) * 5/60;
figure(23)
clf
hold on
for i = 1:365
    plot(time(i,:), netEnergy(i,:))
end
hold off
title("Surplus/Deficit Energy")
ylabel("Energy [MWh]")
xlabel("Date")

% Storage
potStorage = zeros(365,288);
excess = zeros(365,288);
batStorage = zeros(365,288);
thermStorage = zeros(365,288);
batMax = 250;
thermMax = 70;
batEff = 0.99;
thermEff = 0.6;
prev = struct("bat", 0, "therm", 0, "excess", 0);

for i = 1:365
    for j = 1:288
        delta = -netEnergy(i,j);     % Convert power demand into MWh
        if delta >= 0    % Energy surplus
            if delta > (batMax - prev.bat) * (1 + 1 - batEff)       % More energy than battery space
                batStorage(i,j) = prev.bat + batMax - prev.bat;
                delta = delta - ((batMax - prev.bat) * (1 + 1 - batEff));
            else        % All of delta goes into battery
                batStorage(i,j) = prev.bat + delta;
                delta = 0;
            end
            if delta > (thermMax - prev.therm) * (1 + 1 - thermEff) % More energy than thermal space
                thermStorage(i,j) = prev.therm + (thermMax - prev.therm);
                delta = delta - ((thermMax - prev.therm) * (1 + 1 - thermEff));
                excess(i,j) = prev.excess + delta;
            else        % All of remaining delta goes into thermal
                thermStorage(i,j) = prev.therm + delta;
                excess(i,j) = prev.excess;
            end
        else            % Energy deficit
            if abs(delta) > prev.bat         % More demand than energy stored in battery
                batStorage(i,j) = 0;
                delta = delta + prev.bat;
            else        % Battery fulfills all of demand
                batStorage(i,j) = prev.bat + delta;
                delta = 0;
            end
            if abs(delta) > prev.therm       % More remaining demand than energy stored in thermal
                thermStorage(i,j) = 0;
                delta = delta + prev.therm;
                excess(i,j) = prev.excess + delta;
            else        % Thermal fulfills all of remaining demand
                thermStorage(i,j) = prev.therm + delta;
                excess(i,j) = prev.excess;
            end
        end
        prev.bat = batStorage(i,j);
        prev.therm = thermStorage(i,j);
        prev.excess = excess(i,j);
    end
end
figure(24)
clf
totalStorage = batStorage + thermStorage;
plot(time(day,:), batStorage(day,:))
hold on
plot(time(day,:), thermStorage(day,:))
plot(time(day,:), totalStorage(day,:))
plot(time(day,:), netEnergy(day,:))
hold off
title(strcat("Storage and Load for ", datestr(time(day,1),'mm/dd/yy')))
legend("Battery Storage", "Thermal Storage", "Total Storage", "Load-Generation")
ylabel("Energy [MWh]")
xlabel("Time")

figure(25)
clf
hold on
for i = 1:365
    plot(time(i,:), totalStorage(i,:))
end
hold off
title("Storage over the year")
xlabel("Date")
ylabel("Energy [MWh]")

figure(26)
clf
hold on
for i = 1:365
    plot(time(i,:), excess(i,:))
end
hold off
title("Excess Energy over the year")
ylabel("Energy [MWh]")
xlabel("Time")