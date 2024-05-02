%   Group 1 Exe 7
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


% Getting the data.Bikes, data.Temperature and data.Hour for each data.Season
% First column: Bikes
% Rest columns: Features
Winter = Group1Exe7Fun1(data, "Winter");
Spring = Group1Exe7Fun1(data, "Spring");
Summer = Group1Exe7Fun1(data, "Summer");
Autumn = Group1Exe7Fun1(data, "Autumn");

% Number of hours in a day
num_hours = 24;

seasons = {Winter, Spring, Summer, Autumn};

% fit multiple regression models on the data
[adjR2, best_fitted_regress_models] = Group1Exe7Fun2(seasons, num_hours);

% Define a cell array to store the season names
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

% find the best-fitted regression models the data of each hour in each
% season
max_adjR2 = max(adjR2);
max_indices = find(adjR2 == max_adjR2);

% display them
disp("X = Temperatures(independent variable)")
disp("Y = Rented Bikes Count(targer variable)")
disp(' ')
for i=1:4
    max_adjR2 = max(adjR2(:, :, i), [], 2);
    [a, b] = find(max_adjR2 == adjR2(:, :, i));
    best_fitted_models_for_season = best_fitted_regress_models(a, b, i);
    disp("Best-fitted regression models for the season:"+season_names{i})
    for j=1:num_hours
        disp("Hour " + j +":"+best_fitted_models_for_season{j}+" with adjR2 = " + max_adjR2(j))
    end
    disp('-----------------------------------------------------------------------------------')
end

%% Conclusions
%Based on the regression models that exhibited the best fit and 
% the disparities in the values of the adjR2 metric between linear and
% non-linear models, we conclude that the count of rented bikes 
% demonstrates a non-linear dependence on temperature for each hour of the day.

