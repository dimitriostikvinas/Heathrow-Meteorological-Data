%   Group 1 Exe 9
%   Tikvinas Dimitrios
%   Christos Palaskas


function season = Group1Exe9Fun1(data, season_name)

    % Function's Name : extract_data_for_season
    %In this function we extract all the columns in the dataset for each
    %season excluding the columns Season and Holiday. We also drop the rows
    %where Holiday = 1

    season_num = 1; % Default
    switch(season_name)
        case "Winter"
            season_num = 1;
        case "Spring"
            season_num = 2;
        case "Summer"
            season_num = 3;
        case "Autumn"
            season_num = 4;
    end
    
    season= data(data.Seasons == season_num & data.Holiday == 0, 1:11);
    season_Bikes = season(:, 2);
    season_features = season(:, [1, 3:end]);
    
    % Replace 0 with 24 in the Hour column for compatility issues
    season_features.Hour(season_features.Hour==0) = 24;

    % gather Bikes and Hours for the Season
    season = [season_features season_Bikes];

end