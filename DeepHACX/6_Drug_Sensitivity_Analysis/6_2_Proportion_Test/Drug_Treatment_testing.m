%draw drug treatment analysis for each pair experiment.
function Drug_Treatment_testing(Experments_label, group_label, Selected_vel_fullprotrusion, Selected_Cell_label_fullprotrusion, community_cluster_folder, K_cluster, labels, Exp_label, total_number_folder, file_total_number_perCell)
    mkdir(community_cluster_folder);
    for i = Exp_label
        %find the samples and cluster label.
        Exper_index = find(Experments_label == i);
        Exper_group_label = group_label(Exper_index);
        Exper_vel_fullpro = Selected_vel_fullprotrusion(Exper_index, :);
        Exper_Cell_label_fullpro = {Selected_Cell_label_fullprotrusion{Exper_index}};
        
        total_number_pre_cell_none =  load(fullfile(total_number_folder, file_total_number_perCell{i}));
        total_number_pre_cell = total_number_pre_cell_none.total_number_per_cell;

        %Proportion matrix
        [total_sample_proportion, total_sample_num, cell_name] = draw_proportion_precell_normalized_windows(Exper_Cell_label_fullpro, Exper_vel_fullpro, K_cluster, Exper_group_label, total_number_pre_cell);  
        save(fullfile(community_cluster_folder, [labels{i} '_normalized_windows.mat']), 'total_sample_proportion', 'total_sample_num', 'cell_name');
    end

end
