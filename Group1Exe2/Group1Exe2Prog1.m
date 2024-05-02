%   Group 1 Exe 2
%   Tikvinas Dimitrios
%   Christos Palaskas

clear all

warningState = warning('off', 'all');

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


% Converting the data into an array
table = table2array(data);

% Keeping the data.Bikes values for each Season  
Winter = table(data.Seasons == 1, 2);
Spring = table(data.Seasons == 2, 2);
Summer = table(data.Seasons == 3, 2);
Autumn = table(data.Seasons == 4, 2);

seasons = {Winter, Spring, Summer, Autumn};
season_names = {"Winter", "Spring", "Summer", "Autumn"};

sample_size = 100;

M = 1000;

[similarity_percentage, combinations] = Group1Exe2Fun1(seasons, sample_size, M);

for i=1:length(combinations)
    figure(i);
    subplot(2,1,1)
    histogram(seasons{combinations(i, 1)})
    subplot(2,1,2)
    histogram(seasons{combinations(i, 2)})

    sgtitle([season_names{combinations(i, 1)} '-' season_names{combinations(i, 2)} ' Percentage of similarity is: ' num2str(similarity_percentage(i)) '.' ]);
end

%% Conclusions
% We draw the conclusion that the pairs Winter-Spring, Winter-Summer and
% Spring-Summer have the lowest number of rejections of the
% null-hypothesis, meaning that these three seaons have similarities and
% the Autumn season differs from the rest
