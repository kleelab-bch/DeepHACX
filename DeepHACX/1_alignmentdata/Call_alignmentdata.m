% Add all the functions in the Matlab
addpath(genpath('./Pipeline/Matlab_CustomizedPackages/KLee'));
%
%Alignment Per Experiment
clear all
pool_dminpool = [];
pool_dminpoolv = [];
pool_dminpool_window = [];
pool_dminpool_time = [];
pool_dminpool_cell_marker = [];
pool_dminpool_begining_ending = [];
pool_dminpool_window_cycle = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Per Experiment:
%This section can be run per each experiment. For example: bleb/control 
%Input:
pathname = '\\research.wpi.edu\leelab\Kwonmoo\bleb';
pathname2 = 'WindowingPackage\protrusion_samples';
saved_folder = '..\results\alignmentdata';
prefix_video = '*_Bleb_*';

%Analysis Each Video and Data are saved in the saved_folder.
alignmentdata(pathname, saved_folder, prefix_video, pathname2);

%Aligning all the samples based on protrusion onset and retraction onset.
alignment_pooled = poolNormalizedData(saved_folder);

%Merge all the protrusion data together.
pool_dminpool = [pool_dminpool; alignment_pooled.dminpool];
pool_dminpoolv = [pool_dminpoolv; alignment_pooled.dminpoolv];
pool_dminpool_window = [pool_dminpool_window, alignment_pooled.dminpool_window];
pool_dminpool_time = [pool_dminpool_time, alignment_pooled.dminpool_time];
pool_dminpool_cell_marker = [pool_dminpool_cell_marker, alignment_pooled.dminpool_cell_marker];
pool_dminpool_begining_ending = [pool_dminpool_begining_ending; alignment_pooled.dminpool_begining_ending];
pool_dminpool_window_cycle = [pool_dminpool_window_cycle; alignment_pooled.dminpool_window_cycle];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EndPer Experiment:


%Saved all the data into one structure.
all_dminpool.pool_dminpool = pool_dminpool;
all_dminpool.pool_dminpoolv = pool_dminpoolv;
all_dminpool.pool_dminpool_window = pool_dminpool_window;
all_dminpool.pool_dminpool_time = pool_dminpool_time;
all_dminpool.pool_dminpool_cell_marker = pool_dminpool_cell_marker;
all_dminpool.pool_dminpool_begining_ending = pool_dminpool_begining_ending;
all_dminpool.pool_dminpool_window_cycle = pool_dminpool_window_cycle;

save(fullfile(saved_folder, 'polished_dminpool.mat'), 'all_dminpool');
