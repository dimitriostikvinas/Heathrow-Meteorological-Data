%   Group 1 Exe 5
%   Tikvinas Dimitrios
%   Christos Palaskas


function pearson_corr_coefs_matrix = Group1Exe5Fun2(seasons, num_hours)

    % Function's Name : pearson_corr_coef_calculation
    % In this function we iterate through each season's Bikes and
    % Temperature data and for every hour we calculate the  Pearson correlation coefficient
    % between those two.
    
    num_seasons = size(seasons, 2);
    
    % storing pearson_corr_coefs for every season
    pearson_corr_coefs_matrix = zeros(num_seasons, num_hours);
    
    % for each season
    for j=1:num_seasons
        season = seasons{j};
        % for each hour of the day
        for i=1:num_hours
        
        % Extract bikes and temperatures for the mentioned hour i
        Bikes = season(season(:, 3) == i, 1); % Bikes of the hour i
        Temperatures = season(season(:, 3) == i, 2); % Temperatures of the hour i
        
        % Calculate Person correlation coefficients between bikes and
        % temperatures
        corr_coefs = corrcoef(Bikes, Temperatures);
        pearson_corr_coefs_matrix(j, i) = corr_coefs(1, 2);
    
 
        end
    end


end