function result = boot_acc_total_sample_none(cluster, cell_index )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    load('DMSO_normalized_windows.mat');
    acc_num = total_sample_num(:, cluster);
    win_num = total_sample_num(:, 7);
    
    result = sum(acc_num(cell_index))/sum(win_num(cell_index));
 

end