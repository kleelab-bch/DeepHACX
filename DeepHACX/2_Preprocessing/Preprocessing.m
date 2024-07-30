%Input:
Alignment_folder = '..\results\alignmentdata';
Alignment_file = 'polished_dminpool.mat';

%Main_function
addpath(genpath('.\interpolate_data'));
addpath(genpath('.\denoise'));
addpath(genpath('.\SAX'));

all_dminpool = load(fullfile(Alignment_folder, Alignment_file));

all_dminpool = all_dminpool.all_dminpool;
dminpool_raw = all_dminpool.pool_dminpool;
dminpool = all_dminpool.pool_dminpool;
dminpoolv = all_dminpool.pool_dminpoolv;
dminpool_w = all_dminpool.pool_dminpool_window;
dminpool_t = all_dminpool.pool_dminpool_time;
dminpool_c = all_dminpool.pool_dminpool_cell_marker;
dminpool_begining_end = all_dminpool.pool_dminpool_begining_ending;
dminpool_window_cycle = all_dminpool.pool_dminpool_window_cycle;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1. interpolate_data
name = '..\results\interpolate_data';
mkdir(name);
[dminpool_interpolate, dminpoolv_interpolate] = interpolate_data(dminpool, dminpoolv);
[dminpool_interpolate_raw, ~] = interpolate_data(dminpool_raw, dminpoolv);
[flag, index] = check_NaN_re_index(dminpool_interpolate, dminpoolv_interpolate);
[flag2, index2] = check_NaN_re_index(dminpool_interpolate_raw, dminpoolv_interpolate);
if (~flag) & (~flag2)
    interpolate.dminpool_raw = dminpool_interpolate_raw;
    interpolate.dminpool = dminpool_interpolate;
    interpolate.dminpoolv = dminpoolv_interpolate;
    interpolate.dminpool_t = dminpool_t;
    interpolate.dminpool_w = dminpool_w;
    interpolate.dminpool_c = dminpool_c;
    interpolate.dminpool_be = dminpool_begining_end;
    interpolate.dminpool_wc = dminpool_window_cycle;
    save(fullfile(name, 'dminpool_interpolate.mat'), 'interpolate');
else
     disp([name ': the interpolate data has still missing data;']);
     unique_index = unique([index, index2])
     [v_row, v_col] = size(dminpoolv_interpolate)
     dminpoolv_interpolate = dminpoolv_interpolate(setdiff(1:v_row,unique_index),:);
     dminpool_interpolate = dminpool_interpolate(setdiff(1:v_row,unique_index),:);
     dminpool_interpolate_raw = dminpool_interpolate_raw(setdiff(1:v_row,unique_index),:);
     dminpool_t = dminpool_t(setdiff(1:v_row, unique_index));
     dminpool_w = dminpool_w(setdiff(1:v_row, unique_index));
     dminpool_c = dminpool_c(setdiff(1:v_row, unique_index));
     dminpool_begining_end = dminpool_begining_end(setdiff(1:v_row, unique_index),:);
     dminpool_window_cycle = dminpool_window_cycle(setdiff(1:v_row, unique_index),:);
     flag = check_NaN(dminpool_interpolate, dminpoolv_interpolate);
     flag2 = check_NaN(dminpool_interpolate_raw, dminpoolv_interpolate);
     if (~flag) & (~flag2)
         interpolate.dminpool = dminpool_interpolate;
         interpolate.dminpool_raw = dminpool_interpolate_raw;
         interpolate.dminpoolv = dminpoolv_interpolate;
         interpolate.dminpool_t = dminpool_t;
         interpolate.dminpool_w = dminpool_w;
         interpolate.dminpool_c = dminpool_c;
         interpolate.dminpool_be = dminpool_begining_end;
         interpolate.dminpool_wc = dminpool_window_cycle;
         save(fullfile(name, 'dminpool_interpolate.mat'), 'interpolate');
     else
         print("There are still NaN values");
         exit(0);
     end
end 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2. Denoise
name = '../results/denoise';
mkdir(name);
interpolate_s = load(fullfile('../results/interpolate_data',  'dminpool_interpolate.mat'));
dminpoolv = interpolate_s.interpolate.dminpoolv;
[denoise_distance, dminpoolv] = denoise(name, dminpoolv);
[vel_f_dist, acc_f_dist] = get_vel_f_denoise_distance(denoise_distance, dminpoolv);
save(fullfile(name, 'all_vel_acc.mat'), 'vel_f_dist', 'acc_f_dist');

interpolate_s.interpolate.denoise_distance = denoise_distance;
interpolate_s.interpolate.vel_f_dist = vel_f_dist;
interpolate_s.interpolate.acc_f_dist = acc_f_dist;
save(fullfile(name,  'dminpool_denoised.mat'), 'interpolate_s');

%less than 55
name = '../results/denoise';
left = 196;
right = 251;
pool_s = load(fullfile(name, 'dminpool_denoised.mat'));
pool = pool_s.interpolate_s.interpolate;
%select the sample which length is less than 56
index = isnan(pool.vel_f_dist(:, left:right));
index_sum = sum(index, 2);
index_less_56 = find(index_sum ~= 0);

dminpool_less_56.dminpoolv_f_dist = pool.vel_f_dist(index_less_56,:);
dminpool_less_56.dminpoolacc_f_dist = pool.acc_f_dist(index_less_56,:);
dminpool_less_56.dminpool = pool.dminpool(index_less_56,:);
dminpool_less_56.dminpool_raw = pool.dminpool_raw(index_less_56,:);
dminpool_less_56.dminpoold = pool.denoise_distance(index_less_56,:);
dminpool_less_56.dminpoolt = pool.dminpool_t(index_less_56);
dminpool_less_56.dminpoolw = pool.dminpool_w(index_less_56);
dminpool_less_56.dminpoolc = pool.dminpool_c(index_less_56);
dminpool_less_56.dminpoolwc = pool.dminpool_wc(index_less_56,:);
dminpool_less_56.dminpoolbe = pool.dminpool_be(index_less_56,:);
dminpool_less_56.dminpoolv = pool.dminpoolv(index_less_56,:);


mkdir('../results/less_56');
save(fullfile('../results/less_56', 'dminpool_less_56.mat'), 'dminpool_less_56');

%larger than 56
index = isnan(pool.vel_f_dist(:, left:right));
index_sum = sum(index, 2);
index_more_56 = find(index_sum == 0);
mkdir('../results/larger_56');


dminpool_more_56.dminpoolv_f_dist = pool.vel_f_dist(index_more_56,:);
dminpool_more_56.dminpoolacc_f_dist = pool.acc_f_dist(index_more_56,:);
dminpool_more_56.dminpool = pool.dminpool(index_more_56,:);
dminpool_more_56.dminpool_raw = pool.dminpool_raw(index_more_56,:);
dminpool_more_56.dminpoold = pool.denoise_distance(index_more_56,:);
dminpool_more_56.dminpoolt = pool.dminpool_t(index_more_56);
dminpool_more_56.dminpoolw = pool.dminpool_w(index_more_56);
dminpool_more_56.dminpoolc = pool.dminpool_c(index_more_56);
dminpool_more_56.dminpoolwc = pool.dminpool_wc(index_more_56,:);
dminpool_more_56.dminpoolbe = pool.dminpool_be(index_more_56,:);
dminpool_more_56.dminpoolv = pool.dminpoolv(index_more_56,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3. Feature Representation
%Normr the data
[row, col] = size(dminpool_more_56.dminpoolv_f_dist);
dminpool_more_56.dminpoolv_f_dist_normr = NaN(row, length(dminpool_more_56.dminpoolv(1, left:right)));

for i = 1 : row
    sample = dminpool_more_56.dminpoolv_f_dist(i, left:right);
    nonan_sample = sample(~isnan(sample));
    %guassian normalzied
    dminpool_more_56.dminpoolv_f_dist_normr(i,~isnan(sample)) = (nonan_sample - repmat(mean(nonan_sample, 2), 1, right-left + 1))./repmat(std(nonan_sample, 0, 2), 1, right-left + 1);
    
end

dataset = dminpool_more_56.dminpoolv_f_dist_normr;
[row, col] = size(dataset);
ratio = 4;
alpha_size = 4;
NR_opt = 1;
symbolic_feat_data = NaN(row, col/ratio);
PAA = NaN(row, col/ratio);
PAA_normalized = NaN(row, col/ratio);
for i = 1 : row
    data_marker = ~isnan(dataset(i,:));
    n = ceil(sum(data_marker)/ratio);
    [symbolic_feat_data(i,1:n),PAA_normalized(i,1:n), pointer] = timeseries2symbol(dataset(i,data_marker), length(dataset(i,data_marker)),n, alpha_size, NR_opt);
    PAA(i, 1:n) = PAA_function(dminpool_more_56.dminpoolv(i,left:right), length(dataset(i,data_marker)),n);
    
end
dminpool_more_56.symbolic_data.dminpoolv_f_dist_normr = dminpool_more_56.dminpoolv_f_dist_normr;
dminpool_more_56.symbolic_data.dminpoolv_f_dist = dminpool_more_56.dminpoolv(:, left:right);
dminpool_more_56.symbolic_data.symbolic_feat_data_ratio_4_alpha_size_4 = symbolic_feat_data;
dminpool_more_56.symbolic_data.PAA_normalized_ratio_4_alpha_size_4 = PAA_normalized;
dminpool_more_56.symbolic_data.PAA_ratio_4_alpha_size_4 = PAA;
mean_feat_data = mean_value_feature(symbolic_feat_data, n, PAA);
dminpool_more_56.symbolic_data.mean_feat_data_ratio_4_alpha_size_4 = mean_feat_data;

feat_dist = feature_dist_MIN_DIST(symbolic_feat_data, alpha_size, 1);
save('../results/larger_56/SAX_MIN_DIST_symbolic_feat_data_ratio_4_alpha_size_4.mat', 'feat_dist');

ratio = 2;
alpha_size = 4;
NR_opt = 1;
symbolic_feat_data = NaN(row, col/ratio);
PAA = NaN(row, col/ratio);
PAA_normalized = NaN(row, col/ratio);
for i = 1 : row
    data_marker = ~isnan(dataset(i,:));
    n = ceil(sum(data_marker)/ratio);
    [symbolic_feat_data(i,1:n),PAA_normalized(i,1:n), pointer] = timeseries2symbol(dataset(i,data_marker), length(dataset(i,data_marker)),n, alpha_size, NR_opt);
    PAA(i, 1:n) = PAA_function(dminpool_more_56.dminpoolv(i,left:right), length(dataset(i,data_marker)),n);
end
dminpool_more_56.symbolic_data.symbolic_feat_data_ratio_2_alpha_size_4 = symbolic_feat_data;
dminpool_more_56.symbolic_data.PAA_normalized_ratio_2_alpha_size_4 = PAA_normalized;
dminpool_more_56.symbolic_data.PAA_ratio_2_alpha_size_4 = PAA;
mean_feat_data = mean_value_feature(symbolic_feat_data, n, PAA);
dminpool_more_56.symbolic_data.mean_feat_data_ratio_2_alpha_size_4 = mean_feat_data;

feat_dist = feature_dist_MIN_DIST(symbolic_feat_data, alpha_size, 1);
save('../results/larger_56/SAX_MIN_DIST_symbolic_feat_data_ratio_2_alpha_size_4.mat', 'feat_dist');

ratio = 2;
alpha_size = 8;
NR_opt = 1;
symbolic_feat_data = NaN(row, col/ratio);
PAA = NaN(row, col/ratio);
PAA_normalized = NaN(row, col/ratio);
for i = 1 : row
    data_marker = ~isnan(dataset(i,:));
    n = ceil(sum(data_marker)/ratio);
    [symbolic_feat_data(i,1:n),PAA_normalized(i,1:n), pointer] = timeseries2symbol(dataset(i,data_marker), length(dataset(i,data_marker)),n, alpha_size, NR_opt);
    PAA(i, 1:n) = PAA_function(dminpool_more_56.dminpoolv(i,left:right), length(dataset(i,data_marker)),n);
end
dminpool_more_56.symbolic_data.symbolic_feat_data_ratio_2_alpha_size_8 = symbolic_feat_data;
dminpool_more_56.symbolic_data.PAA_normalized_ratio_2_alpha_size_8 = PAA_normalized;
dminpool_more_56.symbolic_data.PAA_ratio_2_alpha_size_8 = PAA;
mean_feat_data = mean_value_feature(symbolic_feat_data, n, PAA);
dminpool_more_56.symbolic_data.mean_feat_data_ratio_2_alpha_size_8 = mean_feat_data;

feat_dist = feature_dist_MIN_DIST(symbolic_feat_data, alpha_size, 1);
save('../results/larger_56/SAX_MIN_DIST_symbolic_feat_data_ratio_2_alpha_size_8.mat', 'feat_dist');

ratio = 4;
alpha_size = 8;
NR_opt = 1;
symbolic_feat_data = NaN(row, col/ratio);
PAA = NaN(row, col/ratio);
PAA_normalized = NaN(row, col/ratio);
for i = 1 : row
    data_marker = ~isnan(dataset(i,:));
    n = ceil(sum(data_marker)/ratio);
    [symbolic_feat_data(i,1:n),PAA_normalized(i,1:n), pointer] = timeseries2symbol(dataset(i,data_marker), length(dataset(i,data_marker)),n, alpha_size, NR_opt);
    PAA(i, 1:n) = PAA_function(dminpool_more_56.dminpoolv(i,left:right), length(dataset(i,data_marker)),n);
end
dminpool_more_56.symbolic_data.symbolic_feat_data_ratio_4_alpha_size_8 = symbolic_feat_data;
dminpool_more_56.symbolic_data.PAA_normalized_ratio_4_alpha_size_8 = PAA_normalized;
dminpool_more_56.symbolic_data.PAA_ratio_4_alpha_size_8 = PAA;
mean_feat_data = mean_value_feature(symbolic_feat_data, n, PAA);
dminpool_more_56.symbolic_data.mean_feat_data_ratio_4_alpha_size_8 = mean_feat_data;


feat_dist = feature_dist_MIN_DIST(symbolic_feat_data, alpha_size, 1);
save('../results/larger_56/SAX_MIN_DIST_symbolic_feat_data_ratio_4_alpha_size_8.mat', 'feat_dist');

symbolic_data = dminpool_more_56.symbolic_data;
%save(fullfile('./protein_dynamics_retraction_protrusion/larger_56', 'dminpool_more_56_raw.mat'), 'dminpool_more_56');
save(fullfile('../results/larger_56', 'dminpool_more_56.mat'), 'dminpool_more_56');
save(fullfile('../results/larger_56', 'dminpool_more_56_symbolic_data.mat'), 'symbolic_data');