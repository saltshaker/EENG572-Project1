% Plot the load curves for a specific day
% Variable set-up
if exist("sortedData", "var") == 0
    [time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
end
day = 272;
figNum = 10;

PlotLoadDay(day, figNum, time, data);
PlotLoadDurationDay(day, figNum+1, time, sortedData);
