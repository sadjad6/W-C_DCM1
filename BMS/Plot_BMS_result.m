

% Plot FFX BMS for established data

% close all;
clear;
clc;


load('BMS.mat')


%  compute posterior probabilities

sF      = model.subj_lme - min(model.subj_lme);
pp      = exp(sF)./sum(exp(sF));


pp=[pp(1:2); pp(3:4);pp(5:6)];
sF=[sF(1:2); sF(3:4);sF(5:6)];

figure;
subplot(1,3,1)
bar(sF);
title('Bayesian Model Selection (FFX)')
xlabel('Models')
ylabel('Log-evidence (relative)')
set(gca,'XTickLabel',Family.names)
set(gca,'FontSize',14,'FontWeight','bold');
legend({'M1','M2'},'location','northwest','FontSize',10,'FontWeight','normal')
axis square
grid on

% plot posterior probability
subplot(1,3,2)
bar(pp);
title('Bayesian Model Selection (FFX)')
xlabel('Models')
ylabel('Posterior Probability')
set(gca,'XTickLabel',Family.names)
set(gca,'FontSize',14,'FontWeight','bold');
legend({'M1','M2'},'location','northwest','FontSize',10,'FontWeight','normal')
axis square
grid on

subplot(1,3,3)

Nfam = length(Family.post);
bar(1:Nfam,Family.post)
set(gca,'XTick',1:Nfam)
set(gca,'XTickLabel',Family.names)
set(gca,'FontSize',12);
ylabel('Family Posterior Probability')
xlabel('Families')
title('Bayesian Model Selection: FFX')
set(gca,'FontSize',14,'FontWeight','bold');
axis square
grid on

