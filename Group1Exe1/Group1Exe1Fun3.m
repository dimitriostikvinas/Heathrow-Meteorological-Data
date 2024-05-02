%   Group 1 Exe 1
%   Tikvinas Dimitrios
%   Christos Palaskas

function Group1Exe1Fun3(season_name, data, distributions)
    
    % Function's Name : fit_and_plot_results
    % This function is used as a pipeline between the fit_distributions and
    % plot_histogram_and_distribution functions 

    % Initialize subplot
    subplot(2, 2, find(strcmp({'Spring', 'Summer', 'Autumn', 'Winter'}, season_name)));

    % Fit distributions and display results
    fit_results = Group1Exe1Fun1(data, distributions);
    Group1Exe1Fun4(season_name, fit_results);

    % Plot the best-fitted distribution alongside the normalized histogram
    [~, best_fit_index] = min([fit_results.Chi2TestValue]);
    best_distribution = fit_results(best_fit_index).Distribution;
    Group1Exe1Fun2(data, best_distribution, season_name);
end