
%Extract the sample and sample similarity from DeepFeatures.
% Step 1: load the data
folder = '../../2-13-2-19-Vel_analysis/Visualization_Weakly_supervision/Code_v3/individual_experiment';
CK689 = load(fullfile(folder, 'CK689_PCA_2D_v2.mat'));
CK666 = load(fullfile(folder, 'CK666_PCA_2D_v2.mat'));

folder = '../../2-13-2-19-Vel_analysis/Clustering_Weakly_supervision/CK6689_CK666';
Dist_DeepFeature = load(fullfile(folder, 'Dist_euclidean.mat'));
Dist_DeepFeature = Dist_DeepFeature.Dist_euclidean;

%cluster label.
cluster_label_DeepFeature = load(fullfile(folder, 'ordered_cluster_label_K_150.mat'));
cluster_label_DeepFeature = cluster_label_DeepFeature.ordered_cluster_label;

%Selected the truncated sample.
Vel = [CK689.per_Vel(:, 196:251); CK666.per_Vel(:, 196:251)];
Representative_features = [CK689.per_representation_data; CK666.per_representation_data];
%Get the truncated samples.
index = find(sum(~isnan(Vel')) == 56);
%Deep Features
PCA_CK689 = CK689.PCA_score;
PCA_CK666 = CK666.PCA_score;
PCA_score = [PCA_CK689(:, 1:15); PCA_CK666(:, 1:15)];

%Get the Dist and feature space.
Exper_label = [ones(size(PCA_CK689, 1), 1); 2 * ones(size(PCA_CK666, 1), 1)];
Exper_label_truncated = Exper_label(index);
Dist_DeepFeature_truncated = Dist_DeepFeature(index, index);
PCA_score_truncated = PCA_score(index, :);
cluster_label_DeepFeature_truncated = cluster_label_DeepFeature(index);

Vel = [CK689.per_Vel; CK666.per_Vel];
Vel_truncated = Vel(index, :);

%% Mapping Velocity function.
[row, col] = size(Vel_truncated);
Mapping_Vel = NaN(size(Vel_truncated));
for i = 1 : row
    for j = 1 : col
        if ~isnan(Vel_truncated(i, j))
            Mapping_Vel(i, j) = 2 * (sigmf(Vel_truncated(i, j),[0.3 0]) - 0.5);
        end
    end
end
Mapping_Vel = Mapping_Vel(:, 196:251);

Representative_features_truncated = Representative_features(index, :);

CK666_CK689_Cell_label = [CK689.Cell_name, CK666.Cell_name];
Cellname_truncated = {CK666_CK689_Cell_label{index}};

save('truncated_dataset_v2.mat', 'Exper_label_truncated', 'Dist_DeepFeature_truncated', 'PCA_score_truncated', 'cluster_label_DeepFeature_truncated', 'Vel_truncated','Mapping_Vel', 'Cellname_truncated', 'Representative_features_truncated');
save('dist_truncated_v2.mat', 'Dist_DeepFeature_truncated');