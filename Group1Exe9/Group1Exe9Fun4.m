%   Group 1 Exe 9
%   Tikvinas Dimitrios
%   Christos Palaskas


function results = Group1Exe9Fun4(seasons, days_test_size, num_hours, num_seasons)

    % Function's Name : fit_linear_multiple_regression_models
    % In this function we are going to fit a multiple linear regression
    % model on the data for each season and for each hour. We will test it
    % upon the last 20 days of the season, and train it with the rest

    results = cell(num_hours, num_seasons);

    %for each season
    for i=1:num_seasons
        % the specific season interval
        season = seasons{i};

        % find first and last day which will comprise the test set
        last_idxs = find(season.Date == season.Date(end));
        last_idx = last_idxs(end);
        first_idxs = find(season.Date == season.Date(end) - days_test_size);
        first_idx = first_idxs(1);
        
        % split the days of the season into train and test set based on
        % the days_test_size
        test_set = table2array(season(first_idx:last_idx, :));
        train_set = table2array(season(1: first_idx-1, :));

        Y_train = train_set(:, end);
        X_train = train_set(:, 1:end-1);

        Y_test = test_set(:, end);
        X_test = test_set(:, 1:end-1);

        
        % Train the mulitple linear regression model on the train set
        b_multiple = regress(Y_train, [ones(length(train_set), 1) X_train]);    

        %Train the stepwise regression model on the train set
        [b_stepwise, ~, ~,  step_model_vector, stats] = stepwisefit(X_train, Y_train, "display","off");  

        % for each hour of the season
        for j=1:num_hours
            %test data of each day of the season at j hour
            idxs_j_hour = find(X_test(:, 2) == j);

            X_test_j_hour = X_test(idxs_j_hour, :);
            Y_test_j_hour = Y_test(idxs_j_hour);

            %% Multiple Linear Regression

            Y_multiple_pred_j_hour = [ones(length(X_test_j_hour), 1) X_test_j_hour] * b_multiple ;
                

            %% Stepwise Linear Regression

            X_test_j_hour = X_test_j_hour(:, step_model_vector);
            b_stepwise_selected = b_stepwise(step_model_vector);
            b0 = stats.intercept;
            
            Y_stepwise_pred_j_hour = b0 + X_test_j_hour * b_stepwise_selected;


            results{j, i} = {Y_test_j_hour, Y_multiple_pred_j_hour, Y_stepwise_pred_j_hour}; 


        end
    end


end