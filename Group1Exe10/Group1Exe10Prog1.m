%   Group 1 Exe 10
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
Winter = table2array(Group1Exe10Fun1(data, "Winter"));
Spring = table2array(Group1Exe10Fun1(data, "Spring"));
Summer = table2array(Group1Exe10Fun1(data, "Summer"));
Autumn = table2array(Group1Exe10Fun1(data, "Autumn"));

% We found that in the Autumn season there is an incomplete day containing
% data only from 7 AM to 11 PM, that's is why we deleted that day
% completely
Autumn(697:713, :) = [];


seasons = {Winter, Spring, Summer, Autumn};
num_hours = 24;
num_seasons = 4;
lag = 4;

[adjR2_stepwise, adjR2_pca] = deal(zeros(num_seasons, num_hours));
for j=1:num_seasons
    season = seasons{j};

    for h=1:24 
        
        
        Y = season(:, end);
        X = season(:, 1:end-1);
        
        test_idxs = find(season(:, 2) == h);
        X_test = X(test_idxs, :);
        Y_test = Y(test_idxs, :);
        
        [X_train, Y_train] = deal([]);
        hour = h;
        for i=1:lag
        
            if hour-i == 0
                hour = 24 + i;
            end
        
            train_idxs = find(X(:, 2) == hour - i);
            X_train = [X_train ; X(train_idxs, :)]; %#ok<*AGROW>
            Y_train = [Y_train; Y(train_idxs, :)];
        
        end
        
        
        %% Method 1: PCA
        
        % Perform PCA on X_train
        [coeff, score, ~, ~, explained, mu] = pca(X_train);  
        
        % Determine the number of components for 95% cumulative explained variance
        cumulative_explained = cumsum(explained);
        num_components = find(cumulative_explained >= 95, 1);
        
        % Retain the selected principal components in both X_train and X_test
        X_train_pca = score(:, 1:num_components);
        X_test_pca = (X_test - mu) * coeff(:, 1:num_components);
        
        [X_train_pca, X_test_pca] =  deal([ones(length(X_train_pca), 1) X_train_pca], [ones(length(X_test_pca), 1) X_test_pca]);
        
        % Fit Linear Regression Model
        b_linear = regress(Y_train, X_train_pca);
        
        Y_linear_pred = X_test_pca * b_linear ;
        k = length(b_linear) - 1;
        
        adjR2_pca(j, h) = Group1Exe10Fun2(Y_test, Y_linear_pred, k);
        
        %% Method 2: Stepwise Linear Regression
        [b_stepwise, ~, ~,  step_model_vector, stats] = stepwisefit(X_train, Y_train, "display","off");   
                    
        X_test = X_test(:, step_model_vector);
        b_stepwise = b_stepwise(step_model_vector);
        b0 = stats.intercept;
        
        Y_stepwise_pred = b0 + X_test * b_stepwise;
        k = length(b_stepwise) - 1;
        
        adjR2_stepwise(j, h) = Group1Exe10Fun2(Y_test, Y_stepwise_pred, k);
    end
end
