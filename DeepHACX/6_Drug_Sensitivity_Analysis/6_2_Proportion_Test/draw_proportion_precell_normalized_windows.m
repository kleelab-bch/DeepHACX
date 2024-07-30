function [proportion_cell, proportio_cell_num, cell_name] = draw_proportion_precell_normalized_windows(dminpoolc, dminpoolv, K_cluster, cluster_label, total_number_pre_cell)

cell_name = total_number_pre_cell(:, 1)'; %unique(total_number_pre_cell);
num_cell = length(cell_name);

proportion_cell = NaN(num_cell, K_cluster);
proportio_cell_num = NaN(num_cell, K_cluster + 1);
for i = 1 : num_cell
    label = strfind(dminpoolc, cell_name{1, i});
    label = find(not(cellfun('isempty', label)));
    cell_label = cluster_label(label, 1);
    
    
    % Load the total number for this cell
    total_number_of_cell_index = 0;
    for index = 1 : length(total_number_pre_cell)
        if strcmp(total_number_pre_cell{index, 1}, cell_name{1, i})
            total_number_of_cell_index = index;
        end
    end
    
    proportio_cell_num(i, K_cluster + 1) = total_number_pre_cell{total_number_of_cell_index, 2};
    for j = 1 : K_cluster
        proportion_cell(i,j) = length(find(cell_label == j))/total_number_pre_cell{total_number_of_cell_index, 2};
        proportio_cell_num(i,j) = length(find(cell_label == j));
    end        
end
end