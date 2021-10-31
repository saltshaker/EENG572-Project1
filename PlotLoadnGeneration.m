% Plots generation throughout day against load demand
% Forms of generation
[time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
[~, solarPower] = CreateSolarArrays();
[~, windPowerOff, windPowerOn] = CreateWindArrays();
windPower = windPowerOff + windPowerOn;
geoPower = ones(365,288) * 15;
totalGeneration = solarPower + windPower + geoPower;

day = 208;

% Just wind
% figure(20)
% clf
% plot(time(day,:),data(day,:))
% hold on
% plot(time(day,:), windPowerOff(day,:))
% hold off

% Just solar
% figure(21)
% clf
% plot(time(day,:),data(day,:))
% hold on
% plot(time(day,:), solarPower(day,:))
% hold off

% Total generation
figure(22)
clf
plot(time(day,:),data(day,:))
hold on
plot(time(day,:),totalGeneration(day,:))
hold off

% Duck curve 
figure(23)
clf
plot(time(day,:), data(day,:)-solarPower(day,:)-windPower(day,:))