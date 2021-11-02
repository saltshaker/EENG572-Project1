% Plots generation throughout day against load demand
% Forms of generation
[time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
[~, solarPower] = CreateSolarArrays();
[~, windPowerOff, windPowerOn] = CreateWindArrays();
windPower = windPowerOff + windPowerOn;
geoPower = ones(365,288) * 15;
% geoPower(:,109:180) = zeros(365, 72);
totalGeneration = solarPower + windPower + geoPower;

% Solistice/Equinox: 79, 172, 265, 355
% Other days of interest: 45, 69, 208
day = 208;

% Total generation
figure(22)
clf
hold on
plot(time(day,:),data(day,:))
plot(time(day,:),totalGeneration(day,:))
hold off
title(strcat("Load and Generation for ", datestr(time(day,1),'mm/dd/yy')))
xlabel("Time")
ylabel("Power [MW]")
legend("Demand", "Generation")

netPower = data - totalGeneration;
figure(20)
clf
hold on
for i = 1:365
    plot(time(i,:), netPower(i,:))
end
hold off
title("Surplus/Deficit Power")
ylabel("Energy [MWh]")
xlabel("Date")

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
        [batStorage(i,j), thermStorage(i,j), excess(i,j)] = StorageCalculator(delta, prev);
        prev.bat = batStorage(i,j);
        prev.therm = thermStorage(i,j);
        prev.excess = excess(i,j);
    end
end

% Find amount of outages and average time
totalStorage = batStorage + thermStorage;
stillDown = false;
numOfOutages = 0;
outageLengths = duration(nan(100,3));
for i = 1:365
    for j = 1:288
        if stillDown
            if totalStorage(i,j) ~= 0
                stillDown = false;
                numOfOutages = numOfOutages + 1;
                outageStop = time(i,j) - minutes(5);
                outageLengths(numOfOutages) = diff([outageStart outageStop]);
            end
        else
            if totalStorage(i,j) == 0
                stillDown = true;
                outageStart = time(i,j);
            end
        end
    end
end
outageLengths = outageLengths(~isnan(outageLengths));
avgOutageLength = mean(outageLengths);

figure(24)
clf
hold on
plot(time(day,:), batStorage(day,:))
plot(time(day,:), thermStorage(day,:))
plot(time(day,:), totalStorage(day,:))
plot(time(day,:), -netEnergy(day,:))
hold off
title(strcat("Storage and Load for ", datestr(time(day,1),'mm/dd/yy')))
legend("Battery Storage", "Thermal Storage", "Total Storage", "Excess Generation")
ylabel("Energy [MWh]")
xlabel("Time")

figure(25)
clf
hold on
for i = 1:365
    plot(time(i,:), totalStorage(i,:))
end
hold off
title("Storage Over the Year")
xlabel("Date")
ylabel("Energy [MWh]")

figure(26)
clf
hold on
for i = 1:365
    plot(time(i,:), excess(i,:))
end
hold off
title("Excess Energy Over the Year")
ylabel("Energy [MWh]")
xlabel("Time")