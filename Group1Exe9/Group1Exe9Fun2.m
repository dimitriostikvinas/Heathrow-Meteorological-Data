%   Group 1 Exe 9
%   Tikvinas Dimitrios
%   Christos Palaskas


function R2 = Group1Exe9Fun2(Y, Yest)

    % Function's Name : R2_calculation
    % calculate R2 metric based on real target values
    % Y and predicted values Y_pred
    
    n = length(Y);
    
    A = sum((Y-Yest).^2);
    B= sum((Y - mean(Y)).^2);
    
    R2 = 1 - A./B;


end