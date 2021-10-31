% Plots solar and wind throughout day against load demand
[time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
[~, solarPower] = CreateSolarArrays();
[~, windPower] = CreateWindArrays();
geoPower = ones(365,288) * 20;

day = 208;

% Just wind
figure(20)
clf
plot(time(day,:),data(day,:))
hold on
plot(time(day,:), windPower(day,:))
hold off

% Just solar
figure(21)
clf
plot(time(day,:),data(day,:))
hold on
plot(time(day,:), solarPower(day,:))
hold off

% Wind and solar
figure(22)
clf
plot(time(day,:),data(day,:))
hold on
plot(time(day,:),windPower(day,:)+solarPower(day,:))
hold off

% Duck curve
figure(23)
clf
plot(time(day,:), data(day,:)-solarPower(day,:)-windPower(day,:))