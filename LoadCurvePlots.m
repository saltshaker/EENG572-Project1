% Plots various load curves
% Import CSV
if exist("importTable", 'var') == 0
    importTable = readtable('Project 1 - Load Profile');
end
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

%% Plot total load curve
figure(1)
clf
plot(totalTime(1:105408), totalData(1:105408))
xlabel("Date and Time")
ylabel("Load [MW]")
title("Year-long Load Curve")
figure(2)
clf
plot(totalSortedData);
ylabel("Load [MW]")
xlabel("Number of 5 Minute Intervals")
title("Year-long Load Duration Curve")

%% Plot all load curves on one graph
t = timeofday(datetime('2022-01-01 00:00:00') : minutes(5) : datetime('2022-01-01 23:55:00'));
figure(3)
clf
hold on
figure(4)
clf
hold on
for i = 1:367
    figure(3)
    plot(t, data(i,:))
    figure(4)
    plot(sortedData(i,:))
end
figure(3)
hold off
title("All Load Curves Over A Day")
xlabel("Time")
xtickformat("hh:mm")
xlim([min(t) max(t)])
ylabel("Load [MW]")

figure(4)
hold off
xlabel("Number of 5 Minute Intervals")
ylabel("Load [MW]")
title("All Load Duration Curves Over A Day")

%% Plot seasonal load curves based on calendar seasons
t = timeofday(datetime('2022-01-01 00:00:00') : minutes(5) : datetime('2022-01-01 23:55:00'));
figure(5)
clf
figure(6)
clf

% ----------Spring----------
% Load Curve
figure(5)
subplot(2,2,1)
hold on
for i = 80:172          % Data was scaled from 2012, which was a leap year
    plot(t,data(i,:))
end
hold off
xlabel("Time")
xtickformat("hh:mm")
ylabel("Load [MW]")
title("Spring 2022")

% Load Duration
figure(6)
subplot(2,2,1)
hold on
for i = 80:172
    plot(sortedData(i,:))
end
hold off
xlabel("Number of 5 Minute Intervals")
ylabel("Load [MW]")
title("Spring 2022")

% ----------Summer----------
% Load Curve
figure(5)
subplot(2,2,2)
hold on
for i = 173:265
    plot(t,data(i,:))
end
hold off
xlabel("Time")
xtickformat("hh:mm")
ylabel("Load [MW]")
title("Summer 2022")

% Load Duration
figure(6)
subplot(2,2,2)
hold on
for i = 173:265
    plot(sortedData(i,:))
end
hold off
xlabel("Number of 5 Minute Intervals")
ylabel("Load [MW]")
title("Summer 2022")

% ----------Fall----------
% Load Curve
figure(5)
subplot(2,2,3)
hold on
for i = 266:355
    plot(t,data(i,:))
end
hold off
xlabel("Time")
xtickformat("hh:mm")
ylabel("Load [MW]")
title("Fall 2022")

% Load Profile
figure(6)
subplot(2,2,3)
hold on
for i = 266:355
    plot(sortedData(i,:))
end
hold off
xlabel("Number of 5 Minute Intervals")
ylabel("Load [MW]")
title("Fall 2022")

% ----------Winter----------
% Load Curve
figure(5)
subplot(2,2,4)
hold on
for i = [1:79 356:366]
    plot(t,data(i,:))
end
hold off
xlabel("Time")
xtickformat("hh:mm")
ylabel("Load [MW]")
title("Winter 2022")
sgtitle("Load Curves by Season")

% Load Duration
figure(6)
subplot(2,2,4)
hold on
for i = [1:79 356:366]
    plot(sortedData(i,:))
end
hold off
xlabel("Number of 5 Minute Intervals")
ylabel("Load [MW]")
title("Winter 2022")
sgtitle("Load Duration Curves by Season")
