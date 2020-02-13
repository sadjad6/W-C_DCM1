
% close all
restoredefaultpath
clear
clc
% clear classes

%adding path for spm software standard version
addpath('/.../spm12_original/spm12_7487')

%adding path for spm software W-C version
addpath('.../spm12_WC/spm12_r7487')


% I construct models alredy here because they are the same for all subjects
% input
DCM_Fixed.C{1} = [1 0 0;0 0 0;0 0 0];

%bwd M1
DCM_Fixed.B{1} = [0 0 0 ; 0 0 0; 0 0 0];
DCM_Fixed.B{2} = [0 0 0 ; 1 0 0; 0 0 0];
DCM_Fixed.B{3} = [0 0 0 ; 0 0 1; 0 0 0];

%fwd M2
% DCM_Fixed.B{1} = [0 0 0 ; 0 0 0; 0 0 0];
% DCM_Fixed.B{2} = [0 0 0 ; 1 0 0; 0 0 0];
% DCM_Fixed.B{3} = [0 0 0 ; 1 0 0; 0 0 0];


% structural connectivity
% 1st = V1, 2nd = V5, 3rd = SPC

DCM_Fixed.A{1} = [1 1 0;1 1 1; 0 1 1];


% Initialise SPM
spm('Defaults','fMRI');
spm_jobman('initcfg');



% Directory containing the data

data_path = '/zifnas/Sadjad.Sadeghi/new_data/paper_related_codes_figures/review/established_data/GLM/';

% Change working directory

clear matlabbatch

%bilinear model
mkdir([data_path 'DCM_bilinear/']);
matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr([data_path 'DCM_bilinear/']);

%W-C model
% mkdir([data_path 'DCM_WC/']);
% matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr([data_path 'DCM_WC/']);

spm_jobman('run',matlabbatch);

% Clear DCM models

clear DCM

% SPM file, first level analysis, conditions, movement regresors

load(fullfile(data_path,'SPM.mat'));

% Load time-series of STS, your VOI's of interest

load(fullfile(data_path,['VOI_V1_1.mat']),'xY');
DCM.xY(1) = xY;

% Load time-series of IPC, your VOI's of interest

load(fullfile(data_path,['VOI_V5_1.mat']),'xY');
DCM.xY(2) = xY;

% Load time-series of BA44, your VOI's of interest

load(fullfile(data_path,['VOI_SPC_1.mat']),'xY');
DCM.xY(3) = xY;



% Number of regions

DCM.n = length(DCM.xY);

% Number of time points

DCM.v = length(DCM.xY(1).u);

DCM.Y.dt  = SPM.xY.RT;
DCM.Y.X0  = DCM.xY(1).X0;

for i = 1:DCM.n
    DCM.Y.y(:,i)  = DCM.xY(i).u;
    DCM.Y.name{i} = DCM.xY(i).name;
end

% BOLD signal

DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);

% Input signal (Regressor of your GLM)



DCM.U.dt   =  SPM.Sess.U(1).dt;
DCM.U.name = [SPM.Sess.U.name];
DCM.U.u    = [SPM.Sess.U(1).u(33:end,1) ...
    SPM.Sess.U(2).u(33:end,1) ...
    SPM.Sess.U(3).u(33:end,1)];

% Delays

DCM.delays = repmat(SPM.xY.RT,DCM.n,1);

% Time Echo

DCM.TE     = 0.04;

% Options, linear DCM by default

DCM.options.nonlinear  = 0;
DCM.options.two_state  = 0;
DCM.options.stochastic = 0;
DCM.options.centre = 0;
DCM.options.nograph    = 1;

% Loop intrinsec connections (A matrix)

% Matrix A

DCM.a = DCM_Fixed.A{1};

% Matrix B

DCM.b(:,:,1) = DCM_Fixed.B{1};
DCM.b(:,:,2) = DCM_Fixed.B{2};
DCM.b(:,:,3) = DCM_Fixed.B{3};

% Matrix C

DCM.c = DCM_Fixed.C{1};

% DCM.D = DCM_Fixed.D{1};

% Generation of the .mat file

save(strcat(matlabbatch{1}.cfg_basicio.cfg_cd.dir{1,1},'DCM_bwd.mat'),'DCM');

% Estimation of the DCM parameters

[DCM]=spm_dcm_estimate(strcat(matlabbatch{1}.cfg_basicio.cfg_cd.dir{1,1},'DCM_bwd.mat'));


% l  = DCM.M.l;                      % number of regions (responses)
% figure;
% x     = [1:DCM.v]*DCM.Y.dt;
% for i = 1:l
%     subplot(l,1,i);
%     
%     plot(x,DCM.y(:,i),'r',x,DCM.Y.y(:,i),'c');
%     title([DCM.Y.name{i} ': responses and predictions',', Mean-Ob = ', num2str(mean(DCM.Y.y(:,i))), ', Mean-p = ', num2str(mean(DCM.y(:,i)))],'FontSize',10);
%     
%     legend('predicted', 'observed');
%     
%     
% end
% xlabel('time {seconds}');
% h=suptitle(['Free Energy =', num2str(DCM.F)]);
% set(h,'FontSize',10)

