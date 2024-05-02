%   Group 1 Exe 3
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
Winter = Group1Exe3Fun1(data, "Winter");
Spring = Group1Exe3Fun1(data, "Spring");
Summer = Group1Exe3Fun1(data, "Summer");
Autumn = Group1Exe3Fun1(data, "Autumn");

% We found that in the Autumn season there is an incomplete day containing
% data only from 7 AM to 11 PM, that's is why we deleted that day
% completely
Autumn(697:713, :) = [];


% Number of hours in a day
num_hours = 24;
% mean value for testing
mu = 0;
% confidence value
alpha = 0.05;

seasons = {Winter, Spring, Summer, Autumn};

[mean_diff_matrix, reject_matrix] = Group1Exe3Fun2(seasons, mu, alpha, num_hours);

%% Plotting

% Define a cell array to store the season names
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

% Create a figure with 8 subplots (2 for each season)
figure;

for i = 1:4 % Iterate over each season

    % Plot mean difference matrix
    subplot(4, 2, 2*i - 1);
    imagesc(mean_diff_matrix(:,:,i)); 
    colorbar;
    title(['Mean Difference Matrix - ' season_names{i}]);
    xlabel('Hour 1');
    ylabel('Hour 2');
    xticks(1:24);

    % Plot reject matrix
    subplot(4, 2, 2*i);
    imagesc(reject_matrix(:,:,i)); 
    colorbar;
    title(['Hypothesis Test - Reject Matrix - ' season_names{i}]);
    xlabel('Hour 1');
    ylabel('Hour 2');
    xticks(1:24);

end

%% Conclusions 
% We didn't notice any significant difference between each season's
% rejection rate of the zero mean test 

   