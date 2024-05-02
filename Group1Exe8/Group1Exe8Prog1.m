%   Group 1 Exe 8
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
Winter = Group1Exe8Fun1(data, "Winter");
Spring = Group1Exe8Fun1(data, "Spring");
Summer = Group1Exe8Fun1(data, "Summer");
Autumn = Group1Exe8Fun1(data, "Autumn");

seasons = {Winter, Spring, Summer, Autumn};
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

num_hours = 24;
L = 100;
combinations = nchoosek(1:length(seasons), 2);
[R2_season_1, R2_season_2, h_test] = deal(zeros(length(combinations), num_hours));
diff_R2 = zeros(L+1, 1);
alpha = 0.05;

for i=1:length(combinations)
    season_1 = seasons{combinations(i, 1)};
    season_2 = seasons{combinations(i, 2)};
    figure(2*i - 1);
    sgtitle([season_names{combinations(i, 1)}, '-', season_names{combinations(i, 2)}, '(1)'], 'Color', 'red');


    for j=1:num_hours

        season_1_specific_hour = season_1(season_1(:, 3) == j, 1:2);
        season_2_specific_hour = season_2(season_2(:, 3) == j, 1:2);
        
        [X_1, Y_1] = deal(season_1_specific_hour(:, 2), season_1_specific_hour(:, 1));
        [X_2, Y_2] = deal(season_2_specific_hour(:, 2), season_2_specific_hour(:, 1));
        
        [X_1, X_2] = deal([ones(length(X_1), 1) X_1], [ones(length(X_2), 1) X_2]);


        [b_1, ~, ~, ~, stats_1] = regress(Y_1, X_1);            
        R2_season_1(i, j) = stats_1(1);

        [b_2, ~, ~, ~, stats_2] = regress(Y_2, X_2);            
        R2_season_2(i, j) = stats_2(1);


        diff_R2(1) = stats_1(1) - stats_2(1); 
        
        X_sam = [X_1 ; X_2];
        Y_sam = [Y_1 ; Y_2];

        for k=1:L
            idx_perm = randperm(length(X_sam));

            X_perm = X_sam(idx_perm, :);
            Y_perm = Y_sam(idx_perm, :);
            
            X_perm_1 = X_perm(1:length(X_1), :);
            X_perm_2 = X_perm(1 +length(X_1) : end, :);

            Y_perm_1 = Y_perm(1:length(X_1), :);
            Y_perm_2 = Y_perm(1 +length(X_1) : end, :);

            [b_perm_1, ~, ~, ~, stats_1] = regress(Y_perm_1, X_perm_1);            
            
            [b_perm_2, ~, ~, ~, stats_2] = regress(Y_perm_2, X_perm_2);            
    
    
            R2_season_1(i, j, k+1) = stats_1(1);
            R2_season_2(i, j, k+1) = stats_2(1);
            
            diff_R2(k+1) = stats_1(1) - stats_2(1); 
        end

        diff_R2_sorted = sort(diff_R2(2:end));

        lower_bound_idx = round((alpha/2)*L);
        upper_bound_idx = round((1-alpha/2)*L);

        lower_bound = diff_R2_sorted(lower_bound_idx);
        upper_bound = diff_R2_sorted(upper_bound_idx);

        if diff_R2(1) < lower_bound || diff_R2(1) > upper_bound
            h_test(i, j) = 1;
        else
            h_test(i, j) = 0;
        end

        if j > num_hours / 2
            figure(2*i)
            sgtitle([season_names{combinations(i, 1)}, '-', season_names{combinations(i, 2)}, '(2)'], 'Color', 'red');

        end

        % Calculate the subplot index based on the current iteration
        if j == num_hours / 2
            subplotIndex = mod(j, num_hours / 2 + 1 );
        else
            subplotIndex = mod(j, num_hours / 2 + 1 ) + 1;
        end

        % plot the results
        subplot(6, 4, 2 * subplotIndex - 1)
        scatter(X_1(:, 2), Y_1, 9, '.')
        set(gca, 'FontSize', 8);
        hold on
        temp_min = min(X_1(:, 2));
        temp_max = max(X_1(:, 2));
        plot([temp_min temp_max], [b_1(1)+b_1(2)*temp_min b_1(1)+b_1(2)*temp_max])

        title(['hour=' num2str(j)],['R2=' sprintf('%.2f', R2_season_1(i, j)) ' h =' sprintf('%.2f', h_test(i, j)) ],'FontSize',8)
        xlabel('temp','Color','black','FontSize',6)
        ylabel('bikes','Color','black','FontSize',6)


        subplot(6, 4, 2 * subplotIndex )
        scatter(X_2(:, 2), Y_2, 9, '.')
        set(gca, 'FontSize', 8);
        hold on
        temp_min = min(X_2(:, 2));
        temp_max = max(X_2(:, 2));
        plot([temp_min temp_max], [b_2(1)+b_2(2)*temp_min b_2(1)+b_2(2)*temp_max])

        title(['hour=' num2str(j)],['R2=' sprintf('%.2f', R2_season_2(i, j)) ' h =' sprintf('%.2f', h_test(i, j)) ],'FontSize',8)
        xlabel('bikes','Color','black','FontSize',6)
        ylabel('temp','Color','black','FontSize',6)

    end

end

