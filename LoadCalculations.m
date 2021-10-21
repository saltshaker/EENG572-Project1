% Peak, average load, and ramps
% Variable set-up
if exist("sortedData", "var") == 0
    [time, data, sortedData, totalTime, totalData, totalSortedData] = CreateLoadArrays();
end

peaks = repmat(struct("Time", datetime, "Power", 0), 365, 5);

for i = 1:365
    [~, P] = islocalmax(data(i,:));
    timeBuf = time(i, :);
    dataBuf = data(i,:);
    timePeaks = timeBuf(P > 1);
    dataPeaks = dataBuf(P > 1);
    for j = 1:length(timeBuf)
        peaks(i, j) = struct("Time", timePeaks(j), "Power", dataPeaks(j));
    end
end