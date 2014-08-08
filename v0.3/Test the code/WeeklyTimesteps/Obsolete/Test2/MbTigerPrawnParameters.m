% CREATED  18 April 2012
% MODIFIED 20 August 2013

% PURPOSE define the parameters for an delay difference model to be fitted
% to simulated datasets

 %cd('N:\EKP - BioEconomic Analysis\Analysis\delaydifference\')
 
%%% Timeframe and time steps on this monthly model
global timesteps;
years = 1991:2010; % 1979 to 1989 are a 10 years repetition of 1989 as warm-up data
                   % 1991 to 2010 are simulated data going from week 1 to week 52 
timesteps = length(years) * 52;

%%%%% Initialize population dynamic vectors
global Biomass Survival Recruitment Tot_yr_rec

Biomass = zeros(timesteps, 1);
Survival = ones(timesteps, 1);
Recruitment = zeros(timesteps, 1); 
Tot_yr_rec = zeros(length(years), 1); % total recruitment over 1 year

%%% Parameter for somatic growth (in weight) estimates from the weight at age in SimulatePopDynamic.R using Schnute (1985) method
global rho w_12weeksOld w_13weeksOld

rho = 0.968;
w_12weeksOld = 5.72 / 1000;
w_13weeksOld = 7.66 / 1000;

%%% Initial biomasses (guessed visually, hopefully they have no infuence on the fit)
Biomass(1) = 7e6;
Biomass(2) = 6.5e6;

%%% Mortality
global M;
M = 0.045; % Natural mortality, in per week, is assumed to be constant

%%% Fraction spawning
global sp_frac;
sp_frac = 0.6;

