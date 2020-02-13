% structural connectivity
% 1st = V1, 2nd = V5, 3rd = SPC

%DCM specification exactily like Bilinear and W-C model out of the below
%values
DCM = rmfield(DCM,{'a','b','c','d','options'});
 
% spatial models
%==========================================================================
DCM.options.nmm = 'TFM';    % two regional populations (E and I)

% priors on connectivity
%bwd M1
%--------------------------------------------------------------------------
DCM.a{1}        = [0 0 0;1 0 0;0 1 0];
DCM.a{2}        = [0 1 0;0 0 1;0 0 0];
%forward
DCM.b{1}(:,:,1) = [0 0 0;0 0 0;0 0 0];
DCM.b{1}(:,:,2) = [0 0 0;1 0 0;0 0 0];
DCM.b{1}(:,:,3) = [0 0 0;0 0 0;0 0 0];
%backward
DCM.b{2}(:,:,1) = [0 0 0;0 0 0;0 0 0];
DCM.b{2}(:,:,2) = [0 0 0;0 0 0;0 0 0];
DCM.b{2}(:,:,3) = [0 0 0;0 0 1;0 0 0];

DCM.c           = [1 0 0;0 0 0;0 0 0];
DCM.d           = [];

%fwd M2
DCM.a{1}        = [0 0 0;1 0 0;0 1 0];
DCM.a{2}        = [0 1 0;0 0 1;0 0 0];
%forward
DCM.b{1}(:,:,1) = [0 0 0;0 0 0;0 0 0];
DCM.b{1}(:,:,2) = [0 0 0;1 0 0;0 0 0];
DCM.b{1}(:,:,3) = [0 0 0;1 0 0;0 0 0];
%backward
DCM.b{2}(:,:,1) = [0 0 0;0 0 0;0 0 0];
DCM.b{2}(:,:,2) = [0 0 0;0 0 0;0 0 0];
DCM.b{2}(:,:,3) = [0 0 0;0 0 0;0 0 0];

DCM.c           = [1 0 0;0 0 0;0 0 0];
DCM.d           = [];

% Bayesian model inversion
%==========================================================================
DCM.options.maxit = 32;
DCM = spm_dcm_fmri_nmm(DCM);