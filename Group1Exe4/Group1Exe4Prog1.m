%   Group 1 Exe 4
%   Tikvinas Dimitrios
%   Christos Palaskas

clear all

% Data import
% Get the current working directory
currentDir = pwd;

% Specify the relative path to the parent directory
relativePath = '../';

% Combine the current directory with the relative path to get the correct directory
filePath = fullfile(currentDir, relativePath, 'SeoulBike.xlsx');

data = readtable(filePath, 'VariableNamingRule','preserve');

% Changing the data.Date type 
data.Date = datenum(data.Date);


% Getting the data.Bikes and data.Hours for each data.Season
Winter = Group1Exe4Fun1(data, "Winter");
Spring = Group1Exe4Fun1(data, "Spring");
Summer = Group1Exe4Fun1(data, "Summer");
Autumn = Group1Exe4Fun1(data, "Autumn");

seasons = {Winter, Spring, Summer, Autumn};
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};
B = 100;
num_hours = 24;
alpha = 0.05;

[Bootstrap_conf_intervals, combinations, h] = Group1Exe4Fun3(seasons, num_hours, B, alpha);

for i=1:length(combinations)
    figure(i);
    for j=1:num_hours
        plot([Bootstrap_conf_intervals(i, j, 1) Bootstrap_conf_intervals(i, j, 2)],[(j) (j)],'Color','blue')
        hold on
        plot([Bootstrap_conf_intervals(i, j, 1) Bootstrap_conf_intervals(i, j, 2)],[(j) (j)],'Color','blue','Marker','o')
        hold on
        if h(i, j) == 1
            plot(Bootstrap_conf_intervals(i, j, 3),j,'x','Color','red')
        elseif h(i, j) == 0
            plot(Bootstrap_conf_intervals(i, j, 3),j,'x','Color','green')
        end
        hold on
        
    end
    title({[season_names{combinations(i, 1)} '-' season_names{combinations(i, 2)}] ; 'Confidence intervals of diffrence of medians and true diffrence of medians'});
end

