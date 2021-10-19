% Plots the load curve for a given day
% Inputs: day (int), fig (int), time (datetime array), data (double array)
% Outputs: A labelled plot
function [] = PlotLoadDay(day, fig, time, data)
figure(fig)
plot(time(day,:),data(day,:))
title(strcat("Load Curve for ", datestr(time(day,1),'mm/dd/yy')))
xlabel("Time")
ylabel("Load [MW]")