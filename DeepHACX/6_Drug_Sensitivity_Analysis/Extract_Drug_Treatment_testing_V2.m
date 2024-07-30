%Generate for Drug_treatment testing.
load('truncated_dataset.mat');
%%Cluster label.
ordered_cluster_label = load('ordered_CK689_CK666_K_truncated_230_community.mat');
group_label = ordered_cluster_label.ordered_cluster_label';
K_cluster = length(unique(group_label));
%% Step 4: Testing Drug Treatment.
%Drug_Treatment_testing
community_cluster_folder = 'CK689_CK666_K_truncated_230_community';
labels = {'CK689', 'CK666'};
total_number_perwindow = '../08-02-2019-Protrusion_samples_summary_for_each_experiment';
Drug_Treatment_testing(Exper_label_truncated, group_label, Vel_truncated, Cellname_truncated, [community_cluster_folder '/Drug_test_normalized_protrusion_samples/'], K_cluster, labels, min(Exper_label_truncated) : max(Exper_label_truncated), total_number_perwindow);
 