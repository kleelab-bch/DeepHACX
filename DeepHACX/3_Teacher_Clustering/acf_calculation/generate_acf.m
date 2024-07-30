%In this file, we will generate acf data from SAX and try to draw them
%based on t-SNE results.

%read the data from dminpool_56
pathname = '../../SMIFH';
dminpool_more_56 = load(fullfile(pathname, 'larger_56/dminpool_more_56.mat'));
dminpool_more_56 = dminpool_more_56.dminpool_more_56;
symbolic_feat_data_ratio_4_alpha_size_4 = dminpool_more_56.symbolic_data.symbolic_feat_data_ratio_4_alpha_size_4;
dminpoolv_f_dist = dminpool_more_56.symbolic_data.dminpoolv_f_dist;
[num_samples, num_featuers] = size(symbolic_feat_data_ratio_4_alpha_size_4);
time_lag = 50;
i = 1;
symbolic_feat_data_ratio_4_alpha_size_4_acf = zeros(num_samples, num_featuers-1);
%mkdir('./acf_figure');
%mkdir('Vel_SAX_ACF');
for i = 1: num_samples
   symbolic_feat_data_ratio_4_alpha_size_4_acf(i,:) = acf(symbolic_feat_data_ratio_4_alpha_size_4(i,:)', min(time_lag, num_featuers-1));
   %saveas(gcf, fullfile('./acf_figure', ['sample_' num2str(i) '_.fig']));
   close all;
%    figure
%    subplot(3,1,1);
%    plot(1:length(dminpoolv_f_dist(i,:)), dminpoolv_f_dist(i,:));
%    title('Velocity');
%    subplot(3,1,2);
%    plot(1:4:length(dminpoolv_f_dist(i,:)), symbolic_feat_data_ratio_4_alpha_size_4(i,:));
%    title('SAX representation');
%    ylim([0,5]);
%    subplot(3,1,3);
%    plot(1:length(symbolic_feat_data_ratio_4_alpha_size_4_acf(i,:)), symbolic_feat_data_ratio_4_alpha_size_4_acf(i,:));
%    title('Autocorrelation Coefficient Value');
%    saveas(gcf, fullfile('./Vel_SAX_ACF', ['sample' num2str(i) '_.fig']));
%    close all;
end

%save acf
save(fullfile(pathname, 'larger_56/acf_symbolic_feat_data_ratio_4_alpha_size_4_acf.mat'), 'symbolic_feat_data_ratio_4_alpha_size_4_acf');

%load the cluster label
pathname = '../Case_polished_analysis_parameters';
cluster_assignment = load(fullfile(pathname, 'symbolic.feat.data.ratio.4.alpha.size.4dist_acf/0.31/5/cluster_assignment.mat'));
cl = cluster_assignment.cl;
group_label_new = cl;
group_label_new(find(cl == 4)) = 2;
group_label_new(find(cl == 5)) = 2;
%Draw tSNE
no_dims = 2;
initial_dims = 10;
perplexity = 30;
mappedx = tsne(symbolic_feat_data_ratio_4_alpha_size_4_acf, [], no_dims, initial_dims, perplexity);

figure
gscatter(mappedx(:,1), mappedx(:,2), group_label_new);
title('tSNE acf data');
saveas(gcf, fullfile('.', 'tSNE_acf_data_3_raw_dims_10_perplexity_30.fig'));