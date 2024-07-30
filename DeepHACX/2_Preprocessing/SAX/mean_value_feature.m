%%
%represent the data using the mean value, not the 
function mean_feat_data = mean_value_feature(symbolic_feat_data, Symbolic_length, PAA)
    [row, col] = size(PAA);
    mean_feat_data = NaN(row, col);
    for i = 1 : row
        for j = 1 : Symbolic_length
            index = find(symbolic_feat_data(i,:) == j);
            mean_feat_data(i,index) =  mean(PAA(i, index));
        end
    end
