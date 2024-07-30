function K_cluster = Extract_proportion_pre_cell(file_truncated_dataset, file_cluster_label, saved_folder, labels, folder_total_number_perCell, file_total_number_perCell)
%Generate for Drug_treatment testing.
load(file_truncated_dataset);


%Cluster label.
ordered_cluster_label = load(file_cluster_label);
group_label = ordered_cluster_label.ordered_cluster_label';
K_cluster = length(unique(group_label));
%% Step 4: Testing Drug Treatment.
Drug_Treatment_testing(Exper_label_truncated, group_label, Vel_truncated, Cellname_truncated, ...
    [saved_folder '/Drug_Sensitivity/'], K_cluster, labels, ...
    min(Exper_label_truncated) : max(Exper_label_truncated), folder_total_number_perCell, file_total_number_perCell);
end
 