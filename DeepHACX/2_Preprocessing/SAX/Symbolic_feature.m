function [symbolic_feat_data, PAA] = Symbolic_feature(data, N, n, alphab_size, NR_opt)
%calculate the symbolic feature and calculate the MINDIST

[row, col] = size(data);
symbolic_feat_data = zeros(row,n);
PAA = zeros(row, n);
for i = 1: row
[symbolic_feat_data(i,:),PAA(i,:), pointer] = timeseries2symbol(data(i,:), length(data(i,:)),n, alphab_size, NR_opt);
%PAA(i,:) = PAA_from_SAX(data(i,:), length(data(i,:)), n);
end