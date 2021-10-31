function [time, windPower] = CreateWindArrays()
importTable = readtable('2019WindData6.csv');

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