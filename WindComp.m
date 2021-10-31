[time, windPower1] = windOffshoreHelper("2019WindData1.csv");
[time, windPower2] = windOffshoreHelper("2019WindData2.csv");
[time, windPower3] = windOffshoreHelper("2019WindData3.csv");
[time, windPower6] = windOffshoreHelper("2019WindData6.csv");
[time, windPowerL] = windOnshoreHelper("2019WindDataLand.csv");

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
hold off
xlim([1 365]);
legend("1", "2", "3", "6", "L")
means = [mean(windPower1, 'all'), mean(windPower2, 'all'), 
    mean(windPower3, 'all'), mean(windPower6, 'all')];


function [time, windPower] = windOffshoreHelper(file)
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
bladeRadius = 77 / 2;
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

function [time, windPower] = windOnshoreHelper(file)
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
bladeRadius = 77 / 2;
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