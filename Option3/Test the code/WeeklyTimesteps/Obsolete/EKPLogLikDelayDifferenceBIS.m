% CREATED  18 April 2012
% MODIFIED  6 June  2012

% PURPOSE Fit a delay difference model to Eastern King Prawn data using the
% likelihood of observing CPUE assuming they are log-normal distributed

% STATUS working

% BACKGROUND the delay difference model struggle to time series of CPUE if the starting biomasses Biomass(1) and (2) which were fixed are used to fit the time series of data. If nothing is done, the model will return un-realistic estimates to try to reconcile the model with the observation. The solution was to leave the first 2 years of data out of the objective function.

% Fitting the model against CPUEs to estimate catchability, 2 parameters for the distribution of recruitment and 10 total annual recruitment
% EKPdatasets; EKPparameters; [x,fval,exitflag] = fminsearch(@(par) EKPLogLikDelayDifference(par, cpue), [ones(1,13)],  optimset('MaxFunEvals',1e5, 'MaxIter', 1e5, 'Display','iter'))
% Plot observed CPUE against fitted:
% plot(cpue, '--rs'); hold; plot(25:120, x(1)*1e-5 * effort(25:end) ./ (x(1)*1e-5 * effort(25:end) + M) .* Biomass(25:end) .* (1 - exp(- x(1)*1e-5 * effort(25:end) - M)) ./ effort(25:end))

function negLL = EKPLogLikDelayDifference(par, cpue)
global Biomass timesteps M ctch effort Recruitment RecSurvey Survival

%%%%% Allocate individual parameters in vector par to clearer names
catchability_q = par(1) * 1e-5;

% Compute the biomass dynamic
DelayDifference(par);

%% Calculate predicted cpue using only observation from the 25 month onward

% Using Quinn and Deriso (1999) equation for catch (Eq. 1.26 if I remember correctly)
pred_cpue = catchability_q * effort(25:end) ./ (catchability_q * effort(25:end) + M) .* Biomass(25:end) .* (1 - exp(- catchability_q * effort(25:end) - M)) ./ effort(25:end);

% Corresponding CPUEs
cpue_butfirst25 = cpue(25:timesteps);

%--Lognormal likelihood for cpues--
%note: normal likelihood on log transformed data 

% Assuming log of prediction to be distributed as a Gaussian with mean
% equal to the log of CPUE (similar to assuming lognormal distribution of
% CPUE)
%lnpred   = log(pred_cpue); %log of predicted
%diff = log(cpue_butfirst25) - lnpred;

% Assuming the prediction are distribution as a Gaussian with mean CPUE 
diff = cpue_butfirst25 - pred_cpue;
sss = diff.^2;
ss       = sum(diff.^2);
nss = timesteps - 24;
sigma    = sqrt(ss./nss); % Estimate of the variance
disp(sigma)
cpueLL = nss * log(sqrt(2 * pi) * sigma) + 1/(2 * sigma.^2) .* sss;

% Same as above, expressed using Haddon (2001) simplification, Eq. 3.19 
% cpueLL = (nss./2).*(log(2*pi)+(2.*log(sigma))+1);% negative loglikelihood for a logNormal distribution 

negLL = cpueLL;
%negLL = diff.^2;
end

