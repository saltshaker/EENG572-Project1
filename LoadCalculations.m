% Peak, average load, and ramps
% Variable set-up
if exist("sortedData", "var") == 0
    [time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
end

%% Peak Load
% Seems like there is never more than 5 prominent peaks in load
% Entries with Power = 0 should be ignored when using the data
peaks = repmat(struct("Time", datetime, "Power", 0), 365, 5);

for i = 1:365
    [~, P] = islocalmax(data(i,:));
    timeBuf = time(i, :);
    dataBuf = data(i,:);
    timePeaks = timeBuf(P > 1);
    dataPeaks = dataBuf(P > 1);
    for j = 1:length(timePeaks)
        peaks(i, j) = struct("Time", timePeaks(j), "Power", dataPeaks(j));
    end
end

% Plots load over a day with major peaks marked
% PlotLoadPeaksDay(10, 10, time, data, peaks);

%% Average Load
averageLoad = zeros(365,1);

for i = 1:365
    averageLoad(i) = mean(data(i,:));
end

% Plots
% figure(11)
% plot(averageLoad)
% xlabel("Day")
% ylabel("Average Load [MW]")

%% High Ramp Periods

