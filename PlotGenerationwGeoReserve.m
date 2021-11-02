% Plots generation throughout day against load demand
% Forms of generation
[time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
[~, solarPower] = CreateSolarArrays();
[~, windPowerOff, windPowerOn] = CreateWindArrays();
windPower = windPowerOff + windPowerOn;
geoPower = ones(365,288) * 15;
% geoPower(:,109:180) = zeros(365, 72);
totalGeneration = solarPower + windPower + geoPower;

day = 69;

netPower = data - totalGeneration;
netEnergy = (data - totalGeneration) * 5/60;
 
% Storage
excess = zeros(365,288);
batStorage = zeros(365,288);
thermStorage = zeros(365,288);
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

totalStorage = batStorage + thermStorage;

% Reserve Geo Power
storageLowLimit = 0.2 * (batMax + thermMax);
storageHighLimit = 0.5 * (batMax + thermMax);

excessNew = zeros(365,288);
batStorageNew = zeros(365,288);
thermStorageNew = zeros(365,288);
totalGenerationNew = totalGeneration;
prev = struct("bat", 0, "therm", 0, "excess", 0);
prevTotal = 0;

reserveOn = false;
for i = 1:365
    for j = 1:288
        if reserveOn
            if prevTotal > storageHighLimit
                reserveOn = false;
            else
                totalGenerationNew(i,j) = totalGenerationNew(i,j) + 20;
            end
        else
            if prevTotal < storageLowLimit
                reserveOn = true;
                totalGenerationNew(i,j) = totalGenerationNew(i,j) + 20;
            end
        end
        delta = -((data(i,j) - totalGenerationNew(i,j)) * 5/60);
        [batStorageNew(i,j), thermStorageNew(i,j), excessNew(i,j)] = StorageCalculator(delta, prev);
        prev.bat = batStorageNew(i,j);
        prev.therm = thermStorageNew(i,j);
        prev.excess = excessNew(i,j);
        prevTotal = prev.bat + prev.therm;
    end
end

netPowerNew = data - totalGenerationNew;
netEnergyNew = (data - totalGenerationNew) * 5/60;
totalStorageNew = batStorageNew + thermStorageNew;

figure(50)
clf
hold on
plot(time(day-1,:), totalStorageNew(day-1,:), 'Color','#EDB120')
plot(time(day-1,:), totalStorage(day-1,:), 'Color','#7E2F8E')
plot(time(day-1,:), -netEnergy(day-1,:), 'Color','#77AC30')
plot(time(day,:), totalStorageNew(day,:), 'Color','#EDB120')
plot(time(day,:), totalStorage(day,:), 'Color','#7E2F8E')
plot(time(day,:), -netEnergy(day,:), 'Color','#77AC30')
plot(time(day+1,:), totalStorageNew(day+1,:), 'Color','#EDB120')
plot(time(day+1,:), totalStorage(day+1,:), 'Color','#7E2F8E')
plot(time(day+1,:), -netEnergy(day+1,:), 'Color','#77AC30')
hold off
legend("Total Storage", "Old Total", "Excess Generation")
title(strcat("Storage and Load for ", datestr(time(day-1,1),'mm/dd/yy'), ...
    " to ", datestr(time(day+1,1),'mm/dd/yy'), " with Geothermal Reserve"))

figure(52)
clf
hold on
plot(time(day-1,:),data(day-1,:), 'Color','#0072BD')
plot(time(day-1,:),totalGenerationNew(day-1,:), 'Color','#D95319')
plot(time(day-1,:),totalGeneration(day-1,:), 'Color','#EDB120')
plot(time(day,:),data(day,:), 'Color','#0072BD')
plot(time(day,:),totalGenerationNew(day,:), 'Color','#D95319')
plot(time(day,:),totalGeneration(day,:), 'Color','#EDB120')
plot(time(day+1,:),data(day+1,:), 'Color','#0072BD')
plot(time(day+1,:),totalGenerationNew(day+1,:), 'Color','#D95319')
plot(time(day+1,:),totalGeneration(day+1,:), 'Color','#EDB120')
hold off
title(strcat("Load and Generation for ", datestr(time(day-1,1),'mm/dd/yy'), ...
    " to ", datestr(time(day+1,1),'mm/dd/yy'), " with Geothermal Reserve"))
xlabel("Time")
ylabel("Power [MW]")
legend("Demand", "Generation w/Reserve", "Old Generation")

figure(53)
clf
hold on
for i = 1:365
    plot(time(i,:), totalStorageNew(i,:))
end
hold off
title("Storage Over the Year")
xlabel("Date")
ylabel("Energy [MWh]")