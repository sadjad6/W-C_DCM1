# W-C_DCM1
The folder DCM_estimation contains the DCM specification and estimation for bilinear and w-C Models and also EEG-based model.  
The DCM files of the two structural models, as in the figure 3A in the manuscript (backward and forward modulated connections), 
are saved in the GLM folder for each neuronal model, in which you can also find the time series of 3 ROIs and SPM file (datasets are available here https://www.fil.ion.ucl.ac.uk/spm/data/attention/). 
In BMS folder you can use the function [family,model] = compare_families ('log_evidence','family_FFX') to compare the models 
and families according to the figure 3B which the result is saved in BMS file and can be plotted with 'Plot_BMS_result.m'. Finally in
the folder SPM12_r7487 are the modified functions of SPM software contain our modifications to the standard bilinear DCM.
