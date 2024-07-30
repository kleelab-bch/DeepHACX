%find the exactly matched string in the cell array.
function label = string_match(cell_list, name)
num_cell = length(cell_list);

label = {};
label{num_cell} = [];

for i = 1 : num_cell
    if strcmp(cell_list{i}, name)
        label{i} = 1;
    end
end
end