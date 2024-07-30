function dist_matrix = Calculate_distance(samples)
%Calculate the distance between current sample with nearer samples saved in
%nearest_samples.

[numsample, lensample] = size(samples);
rng default
for i = 1 : numsample
    temp_sample = samples(i, :);
    index = isnan(temp_sample);
    index_nan = find(index == 1);
    if ~isempty(index_nan)
        index_length = length(index_nan);
        estimated_mean_value = mean(temp_sample(lensample-index_length-5 : lensample-index_length));
        estimated_random_noise = estimated_mean_value + randn(index_length,1);
        samples(i, index_nan) = estimated_random_noise;
    end
end

%Represent the data by SAX.
%Normr the data
[row, col] = size(samples);
samples_dist_normr = NaN(row, col);

for i = 1 : row
    sample = samples(i,:);
    nonan_sample = sample(~isnan(sample));
    %guassian normalzied
    samples_dist_normr(i,~isnan(sample)) = (nonan_sample - repmat(mean(nonan_sample, 2), 1, col))./repmat(std(nonan_sample, 0, 2), 1, col);
    
end


[row, col] = size(samples_dist_normr);
ratio = 4;
alpha_size = 4;
NR_opt = 1;
symbolic_feat_data = NaN(row, ceil(col/ratio));
for i = 1 : row
    data_marker = ~isnan(samples_dist_normr(i,:));
    n = ceil(sum(data_marker)/ratio);
    [symbolic_feat_data(i,1:n),~, ~] = timeseries2symbol(samples_dist_normr(i,data_marker), length(samples_dist_normr(i,data_marker)),n, alpha_size, NR_opt);
    
end
save('SAX_longer_sample.mat', 'symbolic_feat_data');
%Calculate the ACF
[numsample, lensample] = size(symbolic_feat_data);
ACF_longer_sample = zeros(numsample, lensample-1);
for i = 1: numsample
   ACF_longer_sample(i,:) = acf(symbolic_feat_data(i,:)', lensample-1);
   close all;
end
save('ACF_longer_sample.mat', 'ACF_longer_sample');
%Calculate the Euclidean distance
dist_matrix = squareform(pdist(ACF_longer_sample));
%dist_matrix = pdist2(ACF_longer_sample, ACF_longer_sample, 'euclidean');
%dist_matrix = squareform(dist_matrix);
end