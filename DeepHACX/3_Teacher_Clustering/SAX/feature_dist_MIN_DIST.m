function feat_dist = feature_dist_MIN_DIST(symbolic_feat_data, alphabet_size, compression_ratio)
%Calculate the dist based on the min_dist function.

[row, col] = size(symbolic_feat_data);
feat_dist = zeros(row, row);
for i = 1: row
    for j = i+1: row
        feat_dist(i,j) = min_dist(symbolic_feat_data(i,:), symbolic_feat_data(j,:),alphabet_size, compression_ratio);
        feat_dist(j,i) = feat_dist(i,j);
    end
end