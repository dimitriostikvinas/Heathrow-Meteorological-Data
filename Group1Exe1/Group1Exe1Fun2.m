%   Group 1 Exe 1
%   Tikvinas Dimitrios
%   Christos Palaskas

function Group1Exe1Fun2(data, best_distribution_name, season_name)

    % Function's Name : plot_histogram_and_distribution
    % This function is used to plot the normalized histogram of the pdf of
    % the given data alongside with the best-fitted distribution pdf for
    % visualization purposes

    % Plot normalized histogram
    histogram(data, 'Normalization', 'pdf', 'EdgeColor', 'w');
    hold on;
    
    best_distribution = fitdist(data, best_distribution_name);

    % Plot the best distribution
    x_values = linspace(min(data), max(data), 100);
    y_values = pdf(best_distribution, x_values);
    plot(x_values, y_values, 'LineWidth', 2);

    % Set plot title and labels
    title(['Season: ', season_name, newline, 'Best Fitted Distribution: ', best_distribution_name]);
    xlabel('Bikes');
    ylabel('pdf');

    % Add legend
    legend('Normalized Histogram', best_distribution_name);

    hold off;
end