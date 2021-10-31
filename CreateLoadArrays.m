% Stand-alone function to import csv file and create all needed arrays
% Inputs: None
% Outputs: time (367x288 datetime array), data (367x288 double array),
% sortedData (367x288 double array), totalTime(105696x1 datetime array),
% totalData (105696x1 double array), totalSortedData (105696x1 double array)
function [time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays()
importTable = readtable('data/Project 1 - Load Profile');
importTable([16993:17280, 105409:105696], :) = [];      % Removes the leap day and random 2021 day
totalTime = importTable{:,1};
totalData = importTable{:,2};
totalSortedData = sort(totalData, "descend");

% Preallocate arrays
time = NaT(365,288);
data = zeros(365,288);
sortedData = zeros(365,288);

for i = 1:365
    time(i,:) = importTable{1+288*(i-1):i*288,1};
    data(i,:) = importTable{1+288*(i-1):i*288,2};
    sortedData(i,:) = sort(data(i,:),"descend");
end