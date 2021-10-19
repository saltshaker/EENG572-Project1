% Plot the load curves for a specific day
% Variable set-up
[time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
day = 1;
figNum = 10;

PlotLoadDay(day, figNum, time, data);
PlotLoadDurationDay(day, figNum+1, time, sortedData);
