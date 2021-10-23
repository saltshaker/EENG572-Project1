% Plot the load curves for a specific day
% Variable set-up
if exist("sortedData", "var") == 0
    [time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
end
day = 80;
figNum = 10;

PlotLoadDay(day, figNum, time, data);
PlotLoadDurationDay(day, figNum+1, time, sortedData);

%% Plot load curve with peaks and high ramps marked for a specific day
%day = 250;
figNum = 12;

[peaks, avgLoad, ramps] = LoadCalculations(time, data);
PlotLoadPnR(day, figNum, time, data, peaks, ramps);