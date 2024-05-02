%   Group 1 Exe 8
%   Tikvinas Dimitrios
%   Christos Palaskas


function season = Group1Exe8Fun1(data, season_name)

    % Function's Name : extract_data_for_season
    %In this function we extract the Bikes, Temperatures and Hours features from the
    %provided data for the given season_name. We are also replacing 0 with
    %24 in the data.Hours

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
    
    season_Bikes = table2array(data(data.Seasons == season_num, 2));
    season_Temperatures = table2array(data(data.Seasons == season_num, 4));
    season_Hours = table2array(data(data.Seasons == season_num, 3));
    
    % Replace 0 with 24 for compatility issues
    season_Hours(season_Hours == 0) = 24;
    % gather Bikes and Hours for the Season
    season = [season_Bikes season_Temperatures season_Hours];

end