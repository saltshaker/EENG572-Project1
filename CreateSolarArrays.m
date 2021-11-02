% Reads data to create power arrays for residential solar
function [timeNew, solarPowerNew] = CreateSolarArrays()
warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');
importTable = readtable('data/Solar_Residential_Hourly.csv');
warning('on', 'MATLAB:table:ModifiedAndSavedVarnames');

% Preallocate arrays
time = NaT(365,24);
solarPower = zeros(365,24);

for i = 1:365
    time(i,:) = importTable{1+24*(i-1):i*24, 1};
    solarPower(i,:) = importTable{1+24*(i-1):i*24, 2} * 1e-3;
end

solarPower = solarPower .* (solarPower > 0);

% Scaled up for all of San Diego
solarPower = solarPower * 140;

% Wacky interpolation hell
timeNew = NaT(365,288);
solarPowerNew = zeros(365,288);

for i = 1:365
    timeNew(i,:) = time(i,1) : minutes(5) : time(i,24) + minutes(55);
    solarPowerNew(i,:) = interp1(time(i,:), solarPower(i,:), timeNew(i,:));
end
solarPowerNew(isnan(solarPowerNew)) = 0;

