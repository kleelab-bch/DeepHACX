%loading all the DeepHACKS features.
%% load the data
folder = '../../Experiments/2-13-2-19-Vel_analysis/Visualization_Weakly_supervision/Code_v3/individual_experiment';
% load CK689 the data
CK689 = load(fullfile(folder, 'CK689_PCA_2D.mat'));

% load DMSO(CyD) data.
DMSO_CyD = load(fullfile(folder, 'DMSO_CyD_PCA_2D.mat'));

% load DMSO(Bleb) data.
DMSO_Bleb = load(fullfile(folder, 'DMSO_PCA_2D.mat'));

% load Florescence data.
DMSO_Florescence = load(fullfile(folder, 'Florescence_PCA_2D.mat'));

%% extract the truncated features
%Selected the truncated sample.
Vel = [CK689.per_Vel(:, 196:251); DMSO_CyD.per_Vel(:, 196:251); DMSO_Bleb.per_Vel(:, 196:251); DMSO_Florescence.per_Vel(:, 196:251)];
%Get the truncated samples.
index = find(sum(~isnan(Vel')) == 56);
%Deep Features
PCA_score = [CK689.PCA_score(:, 1:15); DMSO_CyD.PCA_score(:, 1:15); DMSO_Bleb.PCA_score(:, 1:15); DMSO_Florescence.PCA_score(:, 1:15)];

%Get the Dist and feature space.
Exper_label = [ones(size(CK689.PCA_score, 1), 1); 2 * ones(size(DMSO_CyD.PCA_score, 1), 1); 3 * ones(size(DMSO_Bleb.PCA_score, 1), 1); 4 * ones(size(DMSO_Florescence.PCA_score, 1), 1)];
Exper_label_truncated = Exper_label(index);
PCA_score_truncated = PCA_score(index, :);
Vel = [CK689.per_Vel; DMSO_CyD.per_Vel; DMSO_Bleb.per_Vel; DMSO_Florescence.per_Vel];
Vel_truncated = Vel(index, :);

CK666_CK689_Cell_label = [CK689.Cell_name, DMSO_CyD.Cell_name, DMSO_Bleb.Cell_name, DMSO_Florescence.Cell_name];
Cellname_truncated = {CK666_CK689_Cell_label{index}};

save('truncated_dataset.mat', 'Exper_label_truncated', 'PCA_score_truncated', 'Vel_truncated', 'Cellname_truncated');

%% calculate the distance
Dist_DeepFeature_truncated = squareform(pdist(PCA_score_truncated));
save('dist_truncated.mat', 'Dist_DeepFeature_truncated');