function symbolic_dataset = SAX(pathname, pool, left, right, feature_length, Symbolic_length)


% pathname = '../interpolate_data';
% left = 176;
% right = 243;
% feature_lengh = 17;
% Symbolic_length = 4;
% pool_s = load(fullfile(pathname, '_dminpool_denoised.mat'));
% pool = pool_s.interpolate_s.interpolate;
 

%Trim the samples in which, there are some NaN.
index = isnan(pool.vel_f_dist(:, left:right));
index_sum = sum(index, 2);
index_nonNaN = find(index_sum == 0);


    
dminpoolv_f_dist_nonNaN = pool.vel_f_dist(index_nonNaN,:);
dminpool_nonNaN = pool.dminpool(index_nonNaN,:);
dminpoold_nonNaN = pool.denoise_distance(index_nonNaN,:);
dminpoolt_nonNaN = pool.dminpool_t(index_nonNaN);
dminpoolw_nonNaN = pool.dminpool_w(index_nonNaN);
dminpoolc_nonNaN = pool.dminpool_c(index_nonNaN);
dminpoolwc_nonNaN = pool.dminpool_wc(index_nonNaN,:);
dminpoolbe_nonNaN = pool.dminpool_be(index_nonNaN,:);
%Normalize the data one by one.
raw_interval_data = dminpoolv_f_dist_nonNaN(:, left:right);
%mean_data = raw_interval_data - repmat(mean(raw_interval_data')', 1, right - left + 1);
%normalized_data = mean_data ./ repmat(std(raw_interval_data')', 1, right-left + 1);
%dminpoolv_f_dist_nonNaN(:, left:right) - mean(dminpoolv_f_dist_nonNaN(:, left:right));
normalized_data = raw_interval_data;

[symbolic_feat_data, PAA] = Symbolic_feature(normalized_data, length(dminpoolv_f_dist_nonNaN(1,left:right)), feature_length, Symbolic_length, 1);
mean_feat_data = mean_value_feature(symbolic_feat_data, Symbolic_length, PAA);

%symbolic_feat_data = Symbolic_feature(dminpoolv_f_dist_nonNaN(:, left:right), length(dminpoolv_f_dist_nonNaN(1,left:right)), feature_length, Symbolic_length, 1);
sax_dist = feature_dist_MIN_DIST(symbolic_feat_data, Symbolic_length, 1);

symbolic_dataset.dminpoolv_f_dist = dminpoolv_f_dist_nonNaN;
symbolic_dataset.dminpoolv = pool.dminpoolv(index_nonNaN,:);
symbolic_dataset.dminpool = dminpool_nonNaN;
symbolic_dataset.dminpoold = dminpoold_nonNaN;
symbolic_dataset.dminpoolt = dminpoolt_nonNaN;
symbolic_dataset.dminpoolw = dminpoolw_nonNaN;
symbolic_dataset.dminpoolc = dminpoolc_nonNaN;
symbolic_dataset.dminpool_be = dminpoolbe_nonNaN;
symbolic_dataset.dminpool_wc = dminpoolwc_nonNaN;

symbolic_dataset.sax_dist = sax_dist;
symbolic_dataset.symbolic_feat_data.data = symbolic_feat_data;
symbolic_dataset.symbolic_feat_data.PAA = PAA;
symbolic_dataset.symbolic_feat_data.mean_feat_data = mean_feat_data;
symbolic_dataset.symbolic_feat_data.feature_lengh = feature_length;
symbolic_dataset.symbolic_feat_data.Symbolic_length = Symbolic_length;

save(fullfile(pathname,  ['feature_length_' num2str(feature_length) '_Symbolic_length_' num2str(Symbolic_length) '_symbolic_dataset.mat']), 'symbolic_dataset');
save(fullfile(pathname,  ['feature_length_' num2str(feature_length) '_Symbolic_length_' num2str(Symbolic_length) '_symbolic_data.mat']), 'symbolic_feat_data');    

