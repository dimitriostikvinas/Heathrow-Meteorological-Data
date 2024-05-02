%   Group 1 Exe 9
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

% Changing the data.Date type and subtracting the first day on the dataset
% to use the number of days since then
data.Date = datenum(data.Date) - datenum(data.Date(1));

% Getting the data columns except the data.Season and data.Holiday. Exclude
% rows where data.Holiday = 1
Winter = Group1Exe9Fun1(data, "Winter");
Spring = Group1Exe9Fun1(data, "Spring");
Summer = Group1Exe9Fun1(data, "Summer");
Autumn = Group1Exe9Fun1(data, "Autumn");


seasons = {Winter, Spring, Summer, Autumn};
seasons_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

days_test_size = 20;
num_hours = 24;
num_seasons = 4;

results_a = Group1Exe9Fun3(seasons,days_test_size , num_hours, num_seasons);

results_b = Group1Exe9Fun4(seasons,days_test_size , num_hours, num_seasons);

for k=1:num_seasons
    figure(k);
    sgtitle(seasons_names{k})

    Y = [];
    for i=1:num_hours
        Y = [Y ; results_a{i, k}{1}, results_a{i, k}{2}, results_a{i, k}{3}, results_b{i, k}{2}, results_b{i, k}{3}];
    end
    R2 = zeros(1, 4);
    
    titles = {"Model 1a: Multiple Linear regression trained on each hour's data", "Model 1b: Stepwise Linear regression trained on each hour's data", ...
                                "Model 2a: Multiple Linear regression trained on all the data", "Model 2b: Stepwise Linear regression trained on all the data"};
    
    for i=1:4
        Y_true = Y(:,1);
        Y_est = Y(:, i+1);
    
        R2(i) = Group1Exe9Fun2(Y_true, Y_est);
        
        errors = Y_true - Y_est;
        errors_var = var(errors);
        errors_norm =  errors./sqrt(errors_var);
        
        % Diagnostic plot
        subplot(2, 2, i)
        dotSize = 25;
        scatter(Y_true, errors_norm, dotSize, 'filled');
        yline(0, '-', 'Color', 'k');
        yline([-2, 2], '--', 'Color', 'k');
        ylim([-6, 6]);
        title(titles{i} + newline + "R2 = "+ R2(i));
    
    end
end

%% Final Conclusions
% Based on the diagnostic plots and the R2 metric, we can infer that 
% the 24 models, each trained on hourly data, outperformed the model 
% trained on the entire dataset when evaluated on the test set. 
% This observation suggests that the individual characteristics of each hour
% contribute to the superior performance, 
% and blending all the data may diminish these distinctive features.

