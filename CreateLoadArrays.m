% Stand-alone function to import csv file and create all needed arrays
% Inputs: None
% Outputs: time (367x288 datetime array), data (367x288 double array),
% sortedData (367x288 double array), totalTime(105696x1 datetime array),
% totalData (105696x1 double array), totalSortedData (105696x1 double array)
function [time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays()
importTable = readtable('Project 1 - Load Profile');
totalTime = importTable{:,1};
totalData = importTable{:,2};
totalSortedData = sort(totalData, "descend");

% Preallocate arrays
time = NaT(367,288);
data = zeros(367,288);
sortedData = zeros(367,288);

for i = 1:367
    time(i,:) = importTable{1+288*(i-1):i*288,1};
    data(i,:) = importTable{1+288*(i-1):i*288,2};
    sortedData(i,:) = sort(data(i,:),"descend");
end