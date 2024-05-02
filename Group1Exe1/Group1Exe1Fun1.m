%   Group 1 Exe 1
%   Tikvinas Dimitrios
%   Christos Palaskas

function results = Group1Exe1Fun1(data, distributions)

    % Function's Name : fit_distributions
    % This function is used to apply the fitdist matlab function on the
    % given data for the given distributions and record the Value of the 
    % test statistic chi2gof 

    results = struct('Distribution', {}, 'Chi2TestValue', {});

    for i = 1:length(distributions)
        distribution_name = distributions{i};
        distribution = fitdist(data, distribution_name);

        % Evaluate goodness of fit using chi-square statistic
        [~, ~, stats] = chi2gof(data, 'CDF', distribution, 'Alpha', 0.05);

        % Save results
        results(i).Distribution = distribution_name;
        results(i).Chi2TestValue = stats.chi2stat;

    end
end