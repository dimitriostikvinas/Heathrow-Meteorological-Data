%   Group 1 Exe 4
%   Tikvinas Dimitrios
%   Christos Palaskas

function [results, combinations, h] = Group1Exe4Fun3(seasons, num_hours, B, alpha)

    % Function's Name:

    combinations = nchoosek(1:length(seasons), 2);
    
    % results(:, :, 1) = lower bootstrap ci
    % results(:, :, 2) = upper bootstrap ci
    % results(:, :, 3) = median
    results = zeros(length(combinations), num_hours,  3);    
    
    h = zeros(length(combinations), num_hours);

    for i = 1:length(combinations)
        season_1 = seasons{combinations(i, 1)};
        season_2 = seasons{combinations(i, 2)};
        
        for j = 1:num_hours
            
            vector_1 = season_1(season_1(:, 2) == j);
            vector_2 = season_2(season_2(:, 2) == j);
                        
            n = length(vector_1);
            m = length(vector_2);

            % initial vector_1 and vector_2 put into a pooled sample (pSam)
            pSam = [vector_1; vector_2];

            % calculation of the pooled bootstrap sample
            [~, pSamIndexes] = bootstrp(B, [], pSam);
            
            pBootSam = pSam(pSamIndexes);
            
            % separation into bootstrap samples x and y
            pX = pBootSam(1:n, :);
            pY = pBootSam(n+1: n+m, :);
        
            % calculation of the median for each bootstrap x, y sample 
            % and the diff of their means
            medianX = median(pX);
            medianY = median(pY);
            diffOfMedians = medianX - medianY;
            
            diffOfMediansSorted = sort(diffOfMedians);
            
            % constains the indexes for the low and high bounds of the ci 
            ciBootIndexes = nan([2, 1]);
            ciBootIndexes(1) = fix((alpha/2)*(B+1));
            k = ciBootIndexes(1);
            ciBootIndexes(2) = B + 1 - k;
        
            ciBoot = [diffOfMediansSorted(ciBootIndexes(1)),...
                      diffOfMediansSorted(ciBootIndexes(2))];
            median_value = median(vector_1) - median(vector_2);

            if median_value  < ciBoot(1) || ...
                    median_value > ciBoot(2) 
                h(i, j) = 1;
            end        
            
            results(i, j, 1) = ciBoot(1);
            results(i, j, 2) = ciBoot(2);
            results(i, j, 3) = median_value;
        end
        
    end

    
end