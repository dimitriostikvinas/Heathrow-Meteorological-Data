%   Group 1 Exe 1
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


% Converting the data into an array
table = table2array(data);

% Keeping the data.Bikes values for each Season  
Winter = table(data.Seasons == 1, 2);
Spring = table(data.Seasons == 2, 2);
Summer = table(data.Seasons == 3, 2);
Autumn = table(data.Seasons == 4, 2);


% Define candidate distributions, taken from the "fitdist" documentation
% we used all that didn't produce any kind of error for each and every
% season. We also excluded the Poisson one because it caused warning and
% non-valuable fit
distributions = {
    'BirnbaumSaunders'
    'Exponential'
    'Extreme Value' 
    'Gamma'
    'Generalized Extreme Value' 
    'Generalized Pareto' 
    'Half Normal' 
    'InverseGaussian'
    'Logistic'
    'Loglogistic'
    'Lognormal'
    'Nakagami'
    'Normal'
    'Rayleigh'
    'Rician'
    'tLocationScale'
    'Weibull'
};

% 1. Fit canditate distributions into each season
% 2. Find the best-fitted distribution for each season
% 3. Plot the normalized histogram of each season alongside with the
%       best-fitted distribution pdf
Group1Exe1Fun3('Spring', Spring, distributions);
Group1Exe1Fun3('Summer', Summer, distributions);
Group1Exe1Fun3('Autumn', Autumn, distributions);
Group1Exe1Fun3('Winter', Winter, distributions);

%% Conclusions
% From the subplots we can conclude that Spring, Summer and Autumn have as 
% the best-fitted distribution the Nakagami one, while the Winter has the
% Weibull. So, yes, the best-fitted distribution isn't the same for each
% season of the year


