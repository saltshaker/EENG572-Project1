% Reads in wind data to create power arrays for offshore and onshore
function [time, windPowerOff, windPowerOn] = CreateWindArrays()

% Offshore
warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');
importTable = readtable('data/2019WindData2.csv');

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

windPowerOff = zeros(365,288);
validSpeeds = (windSpeed > cutInSpeed) & (windSpeed < cutOutSpeed);

% 4 turbines
for i =1:365
    windPowerOff(i,:) = 0.45 * 0.5 * pi * bladeRadius^2 * windSpeed(i,:).^3;
end
windPowerOff = windPowerOff .* validSpeeds;
windPowerOff = windPowerOff * 4 * 1E-6;

% Onshore wind
importTable = readtable('data/2019WindDataLand.csv');
warning('on', 'MATLAB:table:ModifiedAndSavedVarnames');

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

windPowerOn = zeros(365,288);
validSpeeds = (windSpeed > cutInSpeed) & (windSpeed < cutOutSpeed);

% 4 turbines
for i = 1:365
    windPowerOn(i,:) = 0.45 * 0.5 * pi * bladeRadius^2 * windSpeed(i,:).^3;
end
windPowerOn = windPowerOn .* validSpeeds;
windPowerOn = windPowerOn * 3 * 1E-6;