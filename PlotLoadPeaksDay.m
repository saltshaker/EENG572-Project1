% Plots the load curve with prominent peaks for a given day
% Inputs: day (int), fig (int), time (datetime array), data (double array),
% peaks (struct array)
% Outputs: A labelled plot
function [] = PlotLoadPeaksDay(day, fig, time, data, peaks)
figure(fig)
clf
PlotLoadDay(day,fig,time,data);
hold on
for i = 1:size(peaks, 2)
    if peaks(day,i).Power == 0
        break
    end
    plot(peaks(day,i).Time, peaks(day,i).Power, '*r')
end
hold off