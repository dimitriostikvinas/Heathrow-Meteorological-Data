%   Group 1 Exe 9
%   Tikvinas Dimitrios
%   Christos Palaskas


function results = Group1Exe9Fun3(seasons, days_test_size, num_hours, num_seasons)

    % Function's Name : fit_linear_multiple_regression_models
    % In this function we are going to fit a multiple linear regression
    % model on the data for each season and for each hour. We will test it
    % upon the last 20 days of the season, and train it with the rest

    results = cell(num_hours, num_seasons);

    %for each season
    for i=1:num_seasons
        % the specific season interval
        season = seasons{i};
        % for each hour of the season
        for j=1:num_hours
            % data of each day of the season at j hour
            season_j_hour = season(season.Hour == j, :);

            % find first and last day which will comprise the test set
            last_idxs = find(season_j_hour.Date == season_j_hour.Date(end));
            last_idx = last_idxs(end);
            first_idxs = find(season_j_hour.Date == season_j_hour.Date(end) - days_test_size);
            first_idx = first_idxs(1);
            
            % split the days of the season into train and test set based on
            % the days_test_size
            test_set = table2array(season_j_hour(first_idx:last_idx, :));
            train_set = table2array(season_j_hour(1: first_idx-1, :));
            
            Y_train = train_set(:, end);
            X_train = train_set(:, 1:end-1);

            Y_test = test_set(:, end);
            X_test = test_set(:, 1:end-1);
            
            %% Multiple Linear Regression
            b_multiple = regress(Y_train, [ones(length(train_set), 1) X_train]);            
 
            Y_multiple_pred = [ones(length(test_set), 1) X_test] * b_multiple ;%X_test
              
            
            %% Stepwise Linear Regression
            [b_stepwise, ~, ~,  step_model_vector, stats] = stepwisefit(X_train, Y_train, "display","off");   
            
            X_test = X_test(:, step_model_vector);
            b_stepwise = b_stepwise(step_model_vector);
            b0 = stats.intercept;
            
            Y_stepwise_pred = b0 + X_test * b_stepwise;
                
        
            results{j, i} = {Y_test, Y_multiple_pred, Y_stepwise_pred}; 

        end
    end


end