%   Group 1 Exe 10
%   Tikvinas Dimitrios
%   Christos Palaskas


function adjR2 = Group1Exe10Fun2(Y, Yest, k)

    % Function's Name : adjR2_calculation
    % calculate adjR2 metric based on real target values
    % Y, predicted values Y_pred and parameter k, indicating the number of
    % parameters in the regression model - 1 
    
    n = length(Y);
    
    A = sum((Y-Yest).^2);
    B= sum((Y - mean(Y)).^2);
    
    adjR2 = 1 - (n-1)/(n - (k + 1)).* A./B;


end