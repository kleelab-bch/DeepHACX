
% Step 1: load the data
load('truncated_dataset.mat');


% Step 2: load the cluster label.
community_cluster_folder = 'CK689_CK666_K_truncated_320_community';
mkdir(community_cluster_folder);
load([community_cluster_folder '.mat']);
group_label = zeros(1, length(cluster_label));
for i = 1 : length(cluster_label)
    group_label(1, i) = str2num(cluster_label{i, 1});
end

ordered_cluster_label = group_label;
% ordered_cluster_label(find(group_label == 1)) = 1;
% ordered_cluster_label(find(group_label == 2)) = 2;
% ordered_cluster_label(find(group_label == 3)) = 5;
ordered_cluster_label(find(group_label == 4)) = 5;
ordered_cluster_label(find(group_label == 5)) = 4;
% ordered_cluster_label(find(group_label == 7)) = 1;
% % ordered_cluster_label(find(group_label == 4)) = 7;
group_label = ordered_cluster_label;
save('ordered_CK689_CK666_K_truncated_320_community.mat', 'ordered_cluster_label');
% Step 3: split the cluster label into two groups
CK689_length = length(find(Exper_label_truncated == 1));
label_CK689 = group_label(1, 1 : CK689_length);
label_CK666 = group_label(1, CK689_length + 1 : end);

Vel_CK689 = Vel_truncated(1 : CK689_length, :);
Vel_CK666 = Vel_truncated( CK689_length + 1 : end, :);

% Step 4: visualization on the Umap space.
% colormap = [94    79   162
%     50   136   189
%    102   194   165
%    171   221   164
%    230   245   152
%    255   255   191
%    254   224   139
%    253   174    97
%    244   109    67
%    213    62    79
%    158     1    66  ] / 255;
colormap = [178,24,43
239,138,98
253,219,199
247,247,247
209,229,240
103,169,207
33,102,172] / 255;

% Step 5: draw the profile on the Velocity space 
% in Velocity space.
[mean_pro_CK689, lower_pro_CK689, upper_pro_CK689] = draw_cluster_profile(label_CK689, Vel_CK689, community_cluster_folder, 'CK689-Vels');
[mean_pro_CK666, lower_pro_CK666, upper_pro_CK666] = draw_cluster_profile(label_CK666, Vel_CK666, community_cluster_folder, 'CK666-Vels');

draw_cluster_heatmap(label_CK689, Vel_CK689, [-3, 8], community_cluster_folder, 'CK689-Vels-heatmap');
draw_cluster_heatmap(label_CK666, Vel_CK666, [-3, 8], community_cluster_folder, 'CK666-Vels-heatmap');

close all;
figure
set(gcf, 'Position', get(0, 'Screensize'));
for i = 1 : max(group_label)
subplot(2, ceil(max(group_label)/2), i);
error_boundary = NaN(length(mean_pro_CK666(i, :)), 2, 3);
error_boundary(:, 1, 1) = mean_pro_CK689(i, :) - lower_pro_CK689(i, :);
error_boundary(:, 2, 1) = upper_pro_CK689(i, :) - mean_pro_CK689(i, :);
error_boundary(:, 1, 2) = mean_pro_CK666(i, :) - lower_pro_CK666(i, :);
error_boundary(:, 2, 2) = upper_pro_CK666(i, :) - mean_pro_CK666(i, :);
boundedline(-100:5:350, [mean_pro_CK689(i, :);mean_pro_CK666(i, :)], error_boundary, 'alpha');
set(gca, 'fontsize', 12);
xlim([-100, 250]);
ylim([-2, 5]);
ylabel('velocity (\mum/min)', 'FontSize', 12);
axis square;
hold on;
line([-100, 250], [0, 0], 'LineWidth', 2, 'LineStyle', '--');
line([0, 0], [-2, 5], 'LineWidth', 2, 'LineStyle', '--'); 
legend({'CK689','CK666'});
end
saveas(gcf, fullfile(community_cluster_folder, ['Vel_clusters_K=' num2str(max(group_label)) 'certain_interval.fig']));

close all;
