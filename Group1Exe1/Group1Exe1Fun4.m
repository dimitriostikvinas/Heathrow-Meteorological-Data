%   Group 1 Exe 1 
%   Tikvinas Dimitrios
%   Christos Palaskas

function Group1Exe1Fun4(season_name, fit_results)
    
    % Function's Name : display_results
    % This function is used to display in the command window the results of
    % the fit_distributions function and the best-fitted distribution for
    % the given season_name

    disp(['Results for ', season_name, ' season:']);
    
    % Display results
    for i = 1:length(fit_results)
        disp(['Distribution: ', fit_results(i).Distribution, ', Chi-Square: ', num2str(fit_results(i).Chi2TestValue)]);
    end
    
    [~, best_fit_index] = min([fit_results.Chi2TestValue]); % Choose the distribution with the minimum chi-square
    disp(['Best fit for ', season_name, ' season: ', fit_results(best_fit_index).Distribution]);
    disp('------------------------');
end