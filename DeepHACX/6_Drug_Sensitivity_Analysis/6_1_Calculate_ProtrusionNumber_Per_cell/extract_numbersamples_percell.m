function total_number_per_cell = extract_numbersamples_percell(Cellname_truncated, Exper_label_truncated, exper_label)
    %for each experiment, we get the index for the specific exper_label.
    Control_index = find(Exper_label_truncated == exper_label);
    
    %Extract the cellname
    Control_cells = {Cellname_truncated{1, Control_index}};
    Control_cell_name = unique(Control_cells);
    %Calculate the number of samples for each cell.
    total_number_per_cell = {};
    for i = 1 : length(Control_cell_name)
        current_cell = Control_cell_name{1, i};
        label = strfind(Control_cells, current_cell);
        label = find(not(cellfun('isempty', label)));
        total_number_per_cell{i, 1} = current_cell;
        total_number_per_cell{i, 2} = length(label);
    end
end