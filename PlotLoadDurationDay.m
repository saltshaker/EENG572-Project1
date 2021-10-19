% Plots the load duration curve for a given day
% Inputs: day (int), fig (int), time (datetime array), sortData (double array)
% Outputs: A labelled plot
function [] = PlotLoadDurationDay(day, fig, time, sortData)
figure(fig)
plot(sortData(day,:))
title(strcat("Load Duration Curve for ", datestr(time(day,1),'mm/dd/yy')))
xlabel("Number of 5 Minute Intervals")
ylabel("Load [MW]")