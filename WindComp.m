% Compares wind power and speed for various locations
[~, windPower1, windSpeed1] = windOffshoreHelper("data/2019WindData1.csv");
[~, windPower2, windSpeed2] = windOffshoreHelper("data/2019WindData2.csv");
[~, windPower3, windSpeed3] = windOffshoreHelper("data/2019WindData3.csv");
[~, windPower6, windSpeed6] = windOffshoreHelper("data/2019WindData6.csv");
[~, windPowerL, windSpeedL] = windOnshoreHelper("data/2019WindDataLand.csv");

windAvg1 = mean(windPower1, 2);
windAvg2 = mean(windPower2, 2);
windAvg3 = mean(windPower3, 2);
windAvg6 = mean(windPower6, 2);
windAvgL = mean(windPowerL, 2);
     
figure(40)
clf
plot(windAvg1)
hold on
plot(windAvg2)
plot(windAvg3)
plot(windAvg6)
plot(windAvgL)
hold off
xlim([1 365]);
legend("1", "2", "3", "6", "L")
means = [mean(windPower1, 'all'), mean(windPower2, 'all'), ...
    mean(windPower3, 'all'), mean(windPower6, 'all'), mean(windPowerL, 'all')];

windAvg1 = mean(windSpeed1, 2);
windAvg2 = mean(windSpeed2, 2);
windAvg3 = mean(windSpeed3, 2);
windAvg6 = mean(windSpeed6, 2);
windAvgL = mean(windSpeedL, 2);
     
figure(41)
clf
plot(windAvg1)
hold on
plot(windAvg2)
plot(windAvg3)
plot(windAvg6)
plot(windAvgL)
hold off
xlim([1 365]);
legend("1", "2", "3", "6", "L")


function [time, windPower, windSpeed] = windOffshoreHelper(file)
importTable = readtable(file);

% Preallocate arrays
time = NaT(365,288);
windSpeed = zeros(365,288);

for i = 1:365
    time(i,:) = datetime(importTable{3+288*(i-1):i*288+2, 1}, importTable{3+288*(i-1):i*288+2, 2}, ...
        importTable{3+288*(i-1):i*288+2, 3}, importTable{3+288*(i-1):i*288+2, 4}, ...
        importTable{3+288*(i-1):i*288+2, 5}, zeros([288 1]));
    windSpeed(i,:) = importTable{3+288*(i-1):i*288+2,7};
end

% GE Turbine
bladeRadius = 150 / 2;
cutInSpeed = 3;
cutOutSpeed = 25;

windPower = zeros(365,288);
validSpeeds = (windSpeed > cutInSpeed) & (windSpeed < cutOutSpeed);

% 4 turbines
for i =1:365
    windPower(i,:) = 0.45 * 0.5 * pi * bladeRadius^2 * windSpeed(i,:).^3;
end
windPower = windPower .* validSpeeds;
windPower = windPower * 4 * 1E-6;

end

function [time, windPower, windSpeed] = windOnshoreHelper(file)
importTable = readtable(file);

% Preallocate arrays
time = NaT(365,288);
windSpeed = zeros(365,288);

for i = 1:365
    time(i,:) = datetime(importTable{3+288*(i-1):i*288+2, 1}, importTable{3+288*(i-1):i*288+2, 2}, ...
        importTable{3+288*(i-1):i*288+2, 3}, importTable{3+288*(i-1):i*288+2, 4}, ...
        importTable{3+288*(i-1):i*288+2, 5}, zeros([288 1]));
    windSpeed(i,:) = importTable{3+288*(i-1):i*288+2,7};
end

% GE Turbine
bladeRadius = 130 / 2;
cutInSpeed = 3;
cutOutSpeed = 25;

windPower = zeros(365,288);
validSpeeds = (windSpeed > cutInSpeed) & (windSpeed < cutOutSpeed);

% 4 turbines
for i =1:365
    windPower(i,:) = 0.45 * 0.5 * pi * bladeRadius^2 * windSpeed(i,:).^3;
end
windPower = windPower .* validSpeeds;
windPower = windPower * 4 * 1E-6;

end