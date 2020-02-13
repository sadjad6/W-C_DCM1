function [family,model] = compare_families (lme,family)
% Bayesian comparison of model families for group studies
% FORMAT [family,model] = spm_compare_families (lme,family)
%
% INPUT:
%
% lme           - array of log model evidences
%                   rows: subjects
%                   columns: models (1..N)
%
% family        - data structure containing family definition and inference parameters:
%                  .infer='RFX' or 'FFX' (default)
%                  .partition  [1 x N] vector such that partition(m)=k signifies that
%                              model m belongs to family k (out of K) eg. [1 1 2 2 2 3 3]
%                  .names      cell array of K family names eg, {'fam1','fam2','fam3'}
%                  .Nsamp      RFX only: Number of samples to get (default=1e4)
%                  .prior      RFX only: 'F-unity' alpha0=1 for each family (default)
%                              or 'M-unity' alpha0=1 for each model (not advised)
%
% OUTPUT:
%
% family        - RFX only:
%                   .alpha0       prior counts
%                   .exp_r        expected value of r
%                   .s_samp       samples from posterior
%                   .xp           exceedance probs
%                - FFX only:
%                   .prior        family priors
%                   .post         family posteriors
%
% model          - RFX only:
%                   .alpha0        prior counts
%                   .exp_r         expected value of r
%                   .r_samp        samples from posterior
%                - FFX only:
%                   .subj_lme      log model ev without subject effects
%                   .prior         model priors
%                   .like          model likelihoods
%                   .posts         model posteriors
%
%__________________________________________________________________________
% Copyright (C) 2009 Wellcome Trust Centre for Neuroimaging

% Will Penny
% $Id: spm_compare_families.m 5007 2012-10-16 14:28:20Z will $

% load matrix of log evidences with dimensions N x M:
load (lme);
%data structure containing family definition and inference parameters
load (family);

[family,model] = spm_compare_families (F,family);


if strcmp(family.infer,'FFX')
    
    %Display results_ families FFX
    
    % M: number of models
    %    M = size(F,2);
    %  compute posterior probabilities
    % ===================================================
    %     sF      = sum(F); % group-wise summed log-evidences
    sF      = F - min(F);  % normalise to avoid numerical overflow
    pp      = exp(sF)./sum(exp(sF));
    
    % plot group-wise summed log-evidences
    % (equivalent to log GBF of best model compared to all others)
    figure;
    subplot(1,2,1)
    % col =[0 0 0];
    colormap(summer);
    bar(sF);
    title('Bayesian Model Selection (FFX)')
    xlabel('Models','FontSize',20,'FontWeight','bold')
    ylabel('Log-evidence (relative)','FontSize',20,'FontWeight','bold')
    set(gca,'FontSize',20);
    axis square
    grid on
    
    
    % plot posterior probability
    subplot(1,2,2)
    % col =[0.6 0.6 0.6];
    % colormap(col);
    bar(pp);
    title('Bayesian Model Selection (FFX)')
    xlabel('Models','FontSize',20,'FontWeight','bold')
    ylabel('Posterior Probability','FontSize',20,'FontWeight','bold')
    set(gca,'FontSize',20);
    axis square
    grid on
   
    %-Display results - families FFX
    %--------------------------------------------------------------
    figure;
    colormap(summer);
    
    Nfam = length(family.post);
    bar(1:Nfam,family.post)
    set(gca,'XTick',1:Nfam)
    set(gca,'XTickLabel',family.names)
    set(gca,'FontSize',20);
    ylabel('Family Posterior Probability','Fontsize',20,'FontWeight','bold')
    xlabel('Families','Fontsize',20,'FontWeight','bold')
    title('Bayesian Model Selection: FFX','Fontsize',20)
    %     axis square
    grid on
    
else
    
    % RFX
    
    % -Display results - families RFX
    figure;
    colormap(summer);
    
    subplot(1,2,1)
    Nfam = length(family.exp_r);
    bar(1:Nfam,family.exp_r)
    set(gca,'XTick',1:Nfam)
    set(gca,'XTickLabel',family.names)
    ylabel('Family Expected Probability','Fontsize',20)
    xlabel('Families','Fontsize',20)
    title('Bayesian Model Selection: RFX','Fontsize',20)
    axis square
    grid on
    
    subplot(1,2,2)
    bar(1:Nfam,family.xp')
    set(gca,'XTick',1:Nfam)
    set(gca,'XTickLabel',family.names)
    ylabel('Family Exceedance Probability','Fontsize',20)
    xlabel('Families','Fontsize',20)
    title('Bayesian Model Selection: RFX','Fontsize',20)
    axis square
    grid on
    
    %Display results of models RFX
    figure;
    subplot(1,2,1)
    % col =[0 0 0];
    colormap(summer);
    bar(model.exp_r);
    title('Bayesian Model Selection (RFX)')
    % xlabel('Models','FontSize',14,'FontWeight','bold')
    ylabel('Model Expected Probability','FontSize',20,'FontWeight','bold')
    set(gca,'FontSize',20);
    axis square
    grid on
    
    
    % plot posterior probability
    subplot(1,2,2)
    % col =[0.6 0.6 0.6];
    % colormap(col);
    bar(model.xp);
    title('Bayesian Model Selection (RFX)')
    % xlabel('Models','FontSize',14,'FontWeight','bold')
    ylabel('Model Exceedance Probability','FontSize',20,'FontWeight','bold')
    set(gca,'FontSize',20);
    axis square
    grid on
    
    
end

return


% RFX
% family.names={'Bilinear Models','WC Models'};
% family.partition=[1 1 1 1 1 2 2 2 2 2];
% family.infer='RFX'
% family.Nsamp= 1e4;
% family.prior='F-unity';

% FFX

% family.names={'Bilinear Models','EEG_base_Models','WC Models'};
% family.partition=[1 1 2 2 3 3];
% family.infer='FFX'
