%   Group 1 Exe 6
%   Tikvinas Dimitrios
%   Christos Palaskas

clear all

% Data import
% Get the current working directory
currentDir = pwd;

% Specify the relative path to the parent directory
relativePath = '../';

% Combine the current directory with the relative path to get the correct directory
filePath = fullfile(currentDir, relativePath, 'SeoulBike.xlsx');

data = readtable(filePath, 'VariableNamingRule','preserve');

% Changing the data.Date type 
data.Date = datenum(data.Date);


% Getting the data.Bikes and data.Hours for each data.Season
Winter = Group1Exe6Fun1(data, "Winter");
Spring = Group1Exe6Fun1(data, "Spring");
Summer = Group1Exe6Fun1(data, "Summer");
Autumn = Group1Exe6Fun1(data, "Autumn");

seasons = {Winter, Spring, Summer, Autumn};
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

num_hours = 24;

[MIC, GMIC, MIC_h, GMIC_h] = deal(zeros(length(seasons), num_hours));
L = 100;
alpha = 0.05;

for i=1:1%length(seasons)
    season = seasons{i};
    figure(i);
    for j=1:1%num_hours
        data = season(season(:, 3) == j, 1:2);

        X = data(:, 1);
        Y = data(:, 2);
        
        bins = length(histcounts(X));
        
        MIC(i, j) =  MutualInformationXY(X, Y, bins)/log10(bins);
        GMIC(i, j) = -0.5.*log10(1 - corr(X, Y)^2)./log10(bins);
        
        [MIC_h(i, j), info_metrics] = Group1Exe6Fun2("MIC", X, Y, bins, L, alpha);
        [GMIC_h(i, j), ~] = Group1Exe6Fun2("GMIC", X, Y, bins, L, alpha);

        % plot the results
        subplot(6, 4, j)
        scatter(X,Y,9, '.')
        set(gca, 'FontSize', 8);
        title(['hour=' num2str(j)],['GMIC=' sprintf('%.2f', GMIC(i, j)) ' MIC=' sprintf('%.2f', MIC(i, j)) ' GMIC_h=' num2str(GMIC_h(i,j)) ' MIC_h=' num2str(MIC_h(i, j))],'FontSize',8)
        xlabel('bikes','Color','green','FontSize',6)
        ylabel('temp','Color','green','FontSize',6)
        
    end
    sgtitle(season_names{i},'Color','red')
end