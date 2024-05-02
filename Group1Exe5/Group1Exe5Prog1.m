%   Group 1 Exe 5
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
Winter = Group1Exe5Fun1(data, "Winter");
Spring = Group1Exe5Fun1(data, "Spring");
Summer = Group1Exe5Fun1(data, "Summer");
Autumn = Group1Exe5Fun1(data, "Autumn");

% Number of hours in a day
num_hours = 24;

seasons = {Winter, Spring, Summer, Autumn};

% Calculating correlation coefficients between Bikes and Temperatures
% across 24-hours for each season
pearson_corr_coefs_matrix = Group1Exe5Fun2(seasons, num_hours);

%% Plotting

% Define a cell array to store the season names
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

% Create a figure with 4 subplots (1 for each season)
figure;

imagesc(pearson_corr_coefs_matrix); 
colormap(flipud(gray));
colorbar;
clim([-1, 1]); 
title('Pearson Correlation Coefficients');
xlabel('Hour');
ylabel('r');
xticks(1:num_hours);
yticks(1:4);
yticklabels(season_names);



% Highlight specific values above the threshold
hold on;
threshold = 0.5;
[row_pos, col_pos] = find(pearson_corr_coefs_matrix > threshold);
scatter(col_pos, row_pos, 'r', 'filled');

% Highlight specific values below the negative threshold
hold on;
[row_neg, col_neg] = find(pearson_corr_coefs_matrix < -threshold);
scatter(col_neg, row_neg, 'b', 'filled');

% Add legend
legend({'r > 0.5', 'r < -0.5'}, 'Location', 'Best');

hold off;

%% Final Conclusions
% Interpretation of Pearson Correlation Coefficients:
%
%   A positive coefficient (closer to 1) indicates a positive correlation
%   between Bikes and Temperatures. As temperature increases, the number of
%   bikes tends to increase. For example, in the Winter, most coefficients
%   are positive >0.5, meaning that the warmer it is, the more bikes are
%   being rented.
%
%   A coefficient near 0 suggests a weak or no linear correlation between
%   the two variables. For example, in the Summer, most coefficients are
%   negatives near zero, indicating that there is only a weak relationship
%   between how warm it is and how many bikes are rented.
%   
%   Except from Summer, in the rest 3 seasons the correlations are mostly
%   positives in the range [0.1, 0.6]. However, there aren't many strong
%   ones indicating trustworthy linear interdependence

   
