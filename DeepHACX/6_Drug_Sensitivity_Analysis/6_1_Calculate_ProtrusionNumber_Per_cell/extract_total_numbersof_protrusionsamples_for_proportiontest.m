%% CK689_CK666
%Extracting the total protrusion samples for each cells for quantitative measurement.
load('../07-26-2019-CK666_truncated_feature_comparison/truncated_dataset.mat');
%for CK689
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 1);
save('total_number_pre_cell_CK689.mat', 'total_number_per_cell');
%for CK666
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 2);
save('total_number_pre_cell_CK666.mat', 'total_number_per_cell');
clear all;

%% DMSO_Bleb
load('../07-29-2019-DMSO_Bleb_truncated_DeepFeatures_comparison/truncated_dataset.mat');
%for DMSO
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 1);
save('total_number_pre_cell_none.mat', 'total_number_per_cell');
%for Bleb
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 2);
save('total_number_pre_cell_bleb.mat', 'total_number_per_cell');
clear all;

%% DMSO_AICAR_CC
load('../07-29-2019-DMSO_AICAR_CC_truncated_DeepFeatures_comparison/truncated_dataset.mat');
%for DMSO
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 1);
save('total_number_pre_cell_DMSO.mat', 'total_number_per_cell');
%for AICAR
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 2);
save('total_number_pre_cell_AICAR.mat', 'total_number_per_cell');
%for CC
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 3);
save('total_number_pre_cell_CC.mat', 'total_number_per_cell');
clear all;
%% DMSO_CyD50_CyD100
load('../07-29-2019-DMSO_CyD_truncated_DeepFeatures_comparison/truncated_dataset.mat');
%for DMSO
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 1);
save('total_number_pre_cell_DMSO_CyD.mat', 'total_number_per_cell');
%for AICAR
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 2);
save('total_number_pre_cell_CyD50.mat', 'total_number_per_cell');
%for CC
total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, 3);
save('total_number_pre_cell_CyD100.mat', 'total_number_per_cell');