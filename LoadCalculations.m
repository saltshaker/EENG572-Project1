% Peak, average load, and ramps
function [peaks, avgLoad, ramps] = LoadCalculations(time, data)
%% Peak Load
% Seems like there is never more than 5 prominent peaks in load
% Entries with Power = 0 should be ignored when using the data
peaks = repmat(struct("Time", datetime, "Power", 0), 365, 5);
prominenceLimit = 1;

for i = 1:365
    [~, P] = islocalmax(data(i,:));
    timeBuf = time(i, :);
    dataBuf = data(i,:);
    timePeaks = timeBuf(P > prominenceLimit);
    dataPeaks = dataBuf(P > prominenceLimit);
    for j = 1:length(timePeaks)
        peaks(i, j) = struct("Time", timePeaks(j), "Power", dataPeaks(j));
    end
end

%% Average Load
avgLoad = zeros(365,1);

for i = 1:365
    avgLoad(i) = mean(data(i,:));
end

%% High Ramp Periods
% Entries with DeltaPower = 0 should be ignored when using the data
ramps = repmat(struct("Time", datetime, "DeltaPower", 0), 365, 5);
prominenceLimit = 0.6;

for i = 1:365
    [~, P] = islocalmax(diff(data(i,:)));
    timeBuf = time(i, :);
    dataBuf = data(i,:);
    timeRampPeaks = timeBuf(P > prominenceLimit);
    dataRampPeaks = dataBuf(P > prominenceLimit);
    for j = 1:length(timeRampPeaks)
        ramps(i, j) = struct("Time", timeRampPeaks(j), "DeltaPower", dataRampPeaks(j));
    end
end