%Call_Drug_Sensitivity_Analysis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Calculate the number of
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%samples per cluster in each
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cell.
%loading the cellname and experiment information.
%load('truncated_dataset.mat');
file_truncated_dataset = '..\results\truncated_dataset.mat';
file_cluster_label = '..\results\ordered_cluster_label_K_360.mat';
saved_folder = '..\results\DMSO_Bleb_K_truncated_360_community';
labels = {'DMSO', 'Bleb'}; %Here, the order should be the same as the Exp list.
folder_total_number_perCell = '..\5_1_Calculate_ProtrusionNumber_Per_cell';
file_total_number = {'total_number_pre_cell_none.mat', 'total_number_pre_cell_bleb.mat'};
%Calculate the number of sampels per cluster in each cell.
K_cluster = Extract_proportion_pre_cell(file_truncated_dataset, file_cluster_label, saved_folder, labels, folder_total_number_perCell, file_total_number);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Drug Sensitivity Test
saved_folder = fullfile(saved_folder, 'Drug_Sensitivity');
CI_aligned = NaN(K_cluster, length(labels), 2);
mean_aligned = NaN(K_cluster, length(labels));
%%%%%Step 1: Bootstrapping 
for exp_index = 1 : length(labels)
    proprotion_structure = load(fullfile(saved_folder, [labels{exp_index} '_normalized_windows.mat']));
    total_sample_num = proprotion_structure.total_sample_num;
    [num_cell, num_column] = size(total_sample_num);
    for index = 1 : K_cluster
        [bootstat_DMSO,bootsam_DMSO]=bootstrp(10000, @boot_acc_total_sample, total_sample_num, index, num_column, 1:num_cell);
        save(fullfile(saved_folder, ['bp_', labels{exp_index}, '_', num2str(index), '_', 'bootstat.mat']), 'bootstat_DMSO');
        mean_aligned(index, exp_index) = mean(bootstat_DMSO);
        CI_aligned(index, exp_index, :) = bootci(10000, {@boot_acc_total_sample, total_sample_num, index, num_column, 1:num_cell},'type','cper');
        save(fullfile(saved_folder, ['CI_', labels{exp_index}, '_', num2str(index), '_', 'bootstat.mat']), 'bootstat_DMSO'); 
    end
end

%%%%%%Step 2: Calculate the P value
pValue  = NaN(K_cluster, length(labels));
for index = 1 : K_cluster
    p_index = 1;
    for exp_index = 1 : length(labels)
        for next_index = (exp_index + 1) : length(labels)
            exp_bootstat = load(fullfile(saved_folder, ['bp_', labels{exp_index}, '_', num2str(index), '_', 'bootstat.mat']));
            next_bootstat = load(fullfile(saved_folder, ['bp_', labels{next_index}, '_', num2str(index), '_', 'bootstat.mat']));
            pValue(index, p_index) = sum(next_bootstat.bootstat_DMSO - exp_bootstat.bootstat_DMSO < 0)/length(exp_bootstat.bootstat_DMSO);
            p_index = p_index + 1;
        end
    end    
end
save(fullfile(saved_folder, 'mean_CI_pvalue.mat'), 'mean_aligned', 'CI_aligned', 'pValue');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Visualization
load(fullfile(saved_folder, 'mean_CI_pvalue.mat'));
CI_aligned(:, :, 1) = mean_aligned - squeeze(CI_aligned(:, :, 1));
CI_aligned(:, :, 2) = squeeze(CI_aligned(:, :, 2)) - mean_aligned;

%Bar plot
figure
h = barwitherr(CI_aligned, mean_aligned);
legend({'None','Bleb'});
ylabel('Cluster Proportion');
xlim([0.5, 6.5]);
set(gca,'XTickLabel',{'1', '2', '3' , '4', '5', '6', '7'});
set(gca, 'fontsize', 14, 'fontname', 'Arial');
axis square
saveas(gcf, fullfile(saved_folder, 'BarPlot.fig'));
