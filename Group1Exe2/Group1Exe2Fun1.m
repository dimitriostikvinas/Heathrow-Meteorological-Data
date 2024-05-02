%   Group 1 Exe 2
%   Tikvinas Dimitrios
%   Christos Palaskas

function [similarity_percentage, combinations] = Group1Exe2Fun1(seasons, sample_size, M)

    % Function's Name : check_similar_distribution_between_seasons
    % This function is used determine whether two seasons have the same
    % distribution. This can be decided by taking M times two random
    % samples from the seasons observed of size sample_size and check if
    % the null-hypothesis test is not rejected.

    combinations = nchoosek(1:length(seasons), 2);
    
    similarity_percentage = zeros(length(combinations), 1);

    for i = 1:length(combinations)
        data_1 = seasons{combinations(i, 1)};
        data_2 = seasons{combinations(i, 2)};
        h_sum = 0;
        for j=1:M
            vector_1 = randperm(length(data_1), sample_size);
            vector_2 = randperm(length(data_2), sample_size);
            
            [~,edges] = histcounts([vector_1, vector_2]); 
    
            Expected = histcounts(vector_1,edges);
                  
            % Perform the chi-square goodness-of-fit test
            [h, ~] = chi2gof(vector_2,'Edges', edges, 'Expected', Expected);
            
            h_sum = h_sum + h;% h == 1 if rejected, h ==0 if not
        end
        similarity_percentage(i) = (M - h_sum) / M;
    end

    
end