%   Group 1 Exe 6
%   Tikvinas Dimitrios
%   Christos Palaskas


function [h, info_metrics] = Group1Exe6Fun2(info_function_name, X, Y, bins, L, alpha)

    % Function's Name : random_permutation_test
    
    info_metrics = zeros(L+1, 1);

    if info_function_name == "MIC"
        info_metrics(1) = MutualInformationXY(X, Y, bins)/log10(bins);
    else 
        info_metrics(1) = -0.5.*log10(1 - corr(X, Y)^2)./log10(bins);
    end
    

    for i=1:L
        Xr = X(randperm(length(X)));

        if info_function_name == "MIC"
            info_metrics(i+1) = MutualInformationXY(Xr, Y, bins)/log10(bins);
        else
            info_metrics(i+1) = -0.5.*log10(1 - corr(Xr, Y)^2)./log10(bins);
        end
    end

    info_metrics_sorted = sort(info_metrics(2:end));

    lower_bound_idx = round((alpha/2)*L);
    upper_bound_idx = round((1-alpha/2)*L);

    lower_bound = info_metrics_sorted(lower_bound_idx);
    upper_bound = info_metrics_sorted(upper_bound_idx);
    if info_metrics(1) < lower_bound || info_metrics(1) > upper_bound
        h = 1;
    else
        h = 0;
    end

end