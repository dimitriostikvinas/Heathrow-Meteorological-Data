%   Group 1 Exe 7
%   Tikvinas Dimitrios
%   Christos Palaskas



function [adjR2, fitted_regress_models] = Group1Exe7Fun2(seasons, num_hours)

    % Function's Name : find_best_fitted_regression_model
    % In this function we iterate through each season's Bikes and
    % Temperatures data and for every hour we fit multiple regression models
    % and determine through the adjR2 metric which fits the data the most.
    % It is going to return the matrix with the adjR2 of every regression
    % model tested and the mathematical expressions of the best-fitted models.
    
    num_seasons = size(seasons, 2);
    num_regress_models = 5;
    
    % storing adjR2 for every season, every hour and every fitted regression model
    adjR2 = zeros(num_hours, num_regress_models,num_seasons);
    % storing the mathematical expression of the fitted regression
    % model
    fitted_regress_models = cell(num_hours, num_regress_models,num_seasons);
    
    % for each season
    for j=1:num_seasons
        season = seasons{j};
        % for each hour of the day
        for i=1:num_hours
        
            % Extract bikes and temperatures for the mentioned hour i
            Bikes = season(season(:, 3) == i, 1); % Bikes of the hour i
            Temperatures = season(season(:, 3) == i, 2); % Temperatures of the hour i
            n = length(Bikes);
            %% Simple Linear Model Y = b0 + b1 * X                
                
                Y = Bikes;
                X = [ones(n, 1) Temperatures];
                
                
                b_linear = regress(Y, X);
                
                Y_est = X * b_linear ;
                
                k = length(b_linear) - 1;

                adjR2(i,1,j) = Group1Exe7Fun3(Y, Y_est, k);
                fitted_regress_models{i, 1, j} = sprintf('Linear Model: Y = %f + %f * X', b_linear(1), b_linear(2));
            
            %% Exponential Model : Y = a*e^(b*X) => ln(Y) = ln(a) + b*X => Yacute = b0 + b1*X
            %%      Yacute = ln(Y), Xacute = X, b0 = ln(a), b1 = b  
                Yacute = log(Bikes);
                Xacute = [ones(n, 1) Temperatures];
                
                b_linear = regress(Yacute, Xacute);
                
                Yacute_est =  Xacute * b_linear ;
                Y_est = exp(Yacute_est);

                a = exp(b_linear(1));
                b =  b_linear(2);

                k = length(b_linear) - 1;

                adjR2(i,2,j) = Group1Exe7Fun3(Y, Y_est, k);
                fitted_regress_models{i, 2, j} = sprintf('Exponential Model: Y = %f*e^(%f * X)', a, b);
            
            
            %% Polynomial model of 2nd degree  : Y = b2*X^2 + b1*X^1 + b0 
                Y = Bikes;
                X = Temperatures;
                coeff = polyfit(X, Y, 2);

                Y_est = coeff(1).*(X).^2 + coeff(2).*(X) + coeff(3);

                k = length(b_linear) - 1;

                adjR2(i,3,j) = Group1Exe7Fun3(Y, Y_est, k);
                fitted_regress_models{i, 3, j} = sprintf('2nd order Polynomial Model: Y = %fX^2 + %fX + %f', coeff(1), coeff(2), coeff(3));
            
            %% Non-Linear Model 1 Y = b0 + b1 * X + b2 * X*Y            
                
                Y = Bikes;
                X = [ones(n, 1) Temperatures Bikes.*Temperatures];
                
                
                b_linear = regress(Y, X);
                
                Y_est = X * b_linear ;
                
                k = length(b_linear) - 1;

                adjR2(i,4,j) = Group1Exe7Fun3(Y, Y_est, k);
                fitted_regress_models{i, 4, j} = sprintf('Non-Linear Model 2: Y = %f + %f * X + %f*X*Y', b_linear(1), b_linear(2), b_linear(3));
            
            %% Non-Linear Model 2 Y = b0 + b1 * X + b2 * X*Y + b3 * (X * Y)^2            
                
                Y = Bikes;
                X = [ones(n, 1) Temperatures Bikes.*Temperatures (Bikes.*Temperatures).^2];
                
                
                b_linear = regress(Y, X);
                
                Y_est = X * b_linear ;
                
                k = length(b_linear) - 1;

                adjR2(i,5,j) = Group1Exe7Fun3(Y, Y_est, k);
                fitted_regress_models{i, 5, j} = sprintf('Non-Linear Model 1: Y = %f + %f * X + %f*X*Y + %f*(X*Y)^2', b_linear(1), b_linear(2), b_linear(3), b_linear(4));
        end
    end


end