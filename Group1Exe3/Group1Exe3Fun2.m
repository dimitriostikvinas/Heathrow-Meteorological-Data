%   Group 1 Exe 3
%   Tikvinas Dimitrios
%   Christos Palaskas


function [mean_diff_matrix, reject_matrix] = Group1Exe3Fun2(seasons, mu, alpha, num_hours)

    % Function's Name : zero_mean_testing
    % In this function we iterate through each season's Bikes count and for
    % every single combination of two hours, we perform ttest to check
    % whether their difference has mean value mu with alpha confidence

    
    % Find all combinations of hours excluding same-hour pairs
    combinations = nchoosek(1:num_hours, 2);
    
    % Add same-hour pairs
    same_hour_pairs = [1:num_hours; 1:num_hours]';
    
    % Concatenate both sets of pairs
    all_combinations = [combinations; same_hour_pairs];
    
    % Number of seasons in a year
    num_seasons = size(seasons, 2);
    
    % storing mean of differences and rejection cases
    mean_diff_matrix = zeros(num_hours, num_hours, num_seasons);
    reject_matrix = zeros(num_hours, num_hours, num_seasons);
    
    % for each season
    for j=1:size(seasons, 2)
        season = seasons{j};
        %for each combination of hours
        for i=1:length(all_combinations)
    
        h1 = all_combinations(i, 1); % first hour
        h2 = all_combinations(i, 2); % second hour
        h1_sample = season(season(:, 2) == h1, 1); % first hour's Bikes
        h2_sample = season(season(:, 2) == h2, 1); % Second hour's Bikes
    
        h_sample = h1_sample - h2_sample; % difference
        
        [h, ~, ~, ~] = ttest(h_sample, mu,...
            'Alpha', alpha); % ttest for zero mean value
        
        [mean_diff_matrix(h1, h2, j), mean_diff_matrix(h2, h1, j)] = deal(mean(h_sample)); % store mean of difference
        
        % when we test for the same hour, instead of getting h=0, we get
        % Nan, so we fix it
        if isnan(h)
            h = 0;
        end
        [reject_matrix(h1, h2, j), reject_matrix(h2, h1, j)] = deal(h); % store ttest result(0 == not rejection, 1 == rejection)
    
        
        end
    end


end