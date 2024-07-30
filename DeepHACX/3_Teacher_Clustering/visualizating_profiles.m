%Do clustering 
% Step 1: load the data
load('Vel.mat');

% Step 2: load the cluster label.
community_cluster_folder = 'DMSO_total_800_truncated_community';
mkdir(community_cluster_folder);
load('DMSO_total_ 800 _truncated_community.mat');
group_label = zeros(1, length(cluster_label));
for i = 1 : length(cluster_label)
    group_label(1, i) = str2num(cluster_label{i, 1});
end

ordered_cluster_label = group_label;
ordered_cluster_label(find(group_label == 1)) = 1;
ordered_cluster_label(find(group_label == 2)) = 2;
ordered_cluster_label(find(group_label == 4)) = 3;
ordered_cluster_label(find(group_label == 6)) = 4;
ordered_cluster_label(find(group_label == 5)) = 5;
ordered_cluster_label(find(group_label == 3)) = 6;
% %ordered_cluster_label(find(group_label == 7)) = 1;
group_label = ordered_cluster_label;
save('ordered_cluster_label_K_800.mat', 'ordered_cluster_label');

% in Velocity space.
[mean_pro_DMSO, lower_pro_DMSO, upper_pro_DMSO] = draw_cluster_profile(group_label, Vel_truncated, community_cluster_folder, 'DMSO-Vels');

%[mean_pro_CC, lower_pro_CC, upper_pro_CC] = draw_cluster_profile(label_CC, Vel_CC, community_cluster_folder, 'CC-Vels');

draw_cluster_heatmap(group_label, Vel_truncated, [-3, 8], community_cluster_folder, 'DMSO-Vels-heatmap');

%draw_cluster_heatmap(label_CC, Vel_CC, [-3, 8], community_cluster_folder, 'CC-Vels-heatmap');

close all;
figure
set(gcf, 'Position', get(0, 'Screensize'));
for i = 1:min(6, max(group_label))%max(group_label)
subplot(2, ceil(6/2), i);
error_boundary = NaN(length(mean_pro_DMSO(i, :)), 2, 1);
error_boundary(:, 1, 1) = mean_pro_DMSO(i, :) - lower_pro_DMSO(i, :);
error_boundary(:, 2, 1) = upper_pro_DMSO(i, :) - mean_pro_DMSO(i, :);
boundedline(-100:5:350, mean_pro_DMSO(i, :), error_boundary, 'alpha');
set(gca, 'fontsize', 12);
xlim([-100, 250]);
ylim([-2, 5]);
ylabel('velocity (\mum/min)', 'FontSize', 12);
axis square;
hold on;
line([-100, 250], [0, 0], 'LineWidth', 2, 'LineStyle', '--');
line([0, 0], [-2, 5], 'LineWidth', 2, 'LineStyle', '--'); 
legend({'DMSO'});
end
saveas(gcf, fullfile(community_cluster_folder, ['Vel_clusters_K=' num2str(max(group_label)) 'certain_interval.fig']));


% 
% % ordered_cluster_label = group_label;
% % ordered_cluster_label(find(group_label == 1)) = 1;
% % ordered_cluster_label(find(group_label == 5)) = 2;
% % ordered_cluster_label(find(group_label == 4)) = 3;
% % ordered_cluster_label(find(group_label == 3)) = 4;
% % ordered_cluster_label(find(group_label == 2)) = 5;
% % ordered_cluster_label(find(group_label == 6)) = 6;
% % %ordered_cluster_label(find(group_label == 6)) = 7;
% % group_label = ordered_cluster_label;
% % save('ordered_cluster_label_K_950.mat', 'ordered_cluster_label');
% % Step 3: split the cluster label into two groups
% DMSO_length = length(find(Exper_label_truncated == 1));
% DMSO_CyD_length = length(find(Exper_label_truncated == 2));
% DMSO_Bleb_length = length(find(Exper_label_truncated == 3));
% DMSO_AICAR_length = length(find(Exper_label_truncated > 3));
% 
% label_DMSO = group_label(1, find(Exper_label_truncated == 1));
% label_DMSO_CyD = group_label(1, find(Exper_label_truncated == 2));
% label_DMSO_Bleb = group_label(1, find(Exper_label_truncated == 3));
% label_DMSO_AICAR = group_label(1, find(Exper_label_truncated > 3));
% %label_CC = group_label(1, DMSO_length + DMSO_CyD_length + 1 : end);
% 
% 
% Vel_DMSO = Vel_truncated(find(Exper_label_truncated == 1), :);
% Vel_DMSO_CyD = Vel_truncated(find(Exper_label_truncated == 2), :);
% Vel_DMSO_Bleb = Vel_truncated(find(Exper_label_truncated == 3), :);
% Vel_DMSO_AICAR = Vel_truncated(find(Exper_label_truncated > 3), :);
% %Vel_CC = Vel_long(DMSO_length + DMSO_CyD_length + 1 : end, :);
% % Step 4: visualization on the Umap space.
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
% 
% % Step 5: draw the profile on the Velocity space 
% % in Velocity space.
% [mean_pro_DMSO, lower_pro_DMSO, upper_pro_DMSO] = draw_cluster_profile(label_DMSO, Vel_DMSO, community_cluster_folder, 'DMSO-Vels');
% [mean_pro_DMSO_CyD, lower_pro_DMSO_CyD, upper_pro_DMSO_CyD] = draw_cluster_profile(label_DMSO_CyD, Vel_DMSO_CyD, community_cluster_folder, 'DMSO_CyD-Vels');
% [mean_pro_DMSO_Bleb, lower_pro_DMSO_Bleb, upper_pro_DMSO_Bleb] = draw_cluster_profile(label_DMSO_Bleb, Vel_DMSO_Bleb, community_cluster_folder, 'DMSO_Bleb-Vels');
% [mean_pro_DMSO_AICAR, lower_pro_DMSO_AICAR, upper_pro_DMSO_AICAR] = draw_cluster_profile(label_DMSO_AICAR, Vel_DMSO_AICAR, community_cluster_folder, 'DMSO_AICAR-Vels');
% 
% %[mean_pro_CC, lower_pro_CC, upper_pro_CC] = draw_cluster_profile(label_CC, Vel_CC, community_cluster_folder, 'CC-Vels');
% 
% draw_cluster_heatmap(label_DMSO, Vel_DMSO, [-3, 8], community_cluster_folder, 'DMSO-Vels-heatmap');
% draw_cluster_heatmap(label_DMSO_CyD, Vel_DMSO_CyD, [-3, 8], community_cluster_folder, 'DMSO_CyD-Vels-heatmap');
% draw_cluster_heatmap(label_DMSO_Bleb, Vel_DMSO_Bleb, [-3, 8], community_cluster_folder, 'DMSO_Bleb-Vels-heatmap');
% draw_cluster_heatmap(label_DMSO_AICAR, Vel_DMSO_AICAR, [-3, 8], community_cluster_folder, 'DMSO_AICAR-Vels-heatmap');
% 
% %draw_cluster_heatmap(label_CC, Vel_CC, [-3, 8], community_cluster_folder, 'CC-Vels-heatmap');
% 
% close all;
% figure
% set(gcf, 'Position', get(0, 'Screensize'));
% for i = 1:max(group_label)
% subplot(2, ceil(10/2), i);
% error_boundary = NaN(length(mean_pro_DMSO_Bleb(i, :)), 2, 4);
% error_boundary(:, 1, 1) = mean_pro_DMSO(i, :) - lower_pro_DMSO(i, :);
% error_boundary(:, 2, 1) = upper_pro_DMSO(i, :) - mean_pro_DMSO(i, :);
% error_boundary(:, 1, 2) = mean_pro_DMSO_CyD(i, :) - lower_pro_DMSO_CyD(i, :);
% error_boundary(:, 2, 2) = upper_pro_DMSO_CyD(i, :) - mean_pro_DMSO_CyD(i, :);
% error_boundary(:, 1, 3) = mean_pro_DMSO_Bleb(i, :) - lower_pro_DMSO_Bleb(i, :);
% error_boundary(:, 2, 3) = upper_pro_DMSO_Bleb(i, :) - mean_pro_DMSO_Bleb(i, :);
% error_boundary(:, 1, 4) = mean_pro_DMSO_AICAR(i, :) - lower_pro_DMSO_AICAR(i, :);
% error_boundary(:, 2, 4) = upper_pro_DMSO_AICAR(i, :) - mean_pro_DMSO_AICAR(i, :);
% boundedline(-100:5:350, [mean_pro_DMSO(i, :); mean_pro_DMSO_CyD(i, :); mean_pro_DMSO_Bleb(i, :); mean_pro_DMSO_AICAR(i, :)], error_boundary, 'alpha');
% set(gca, 'fontsize', 12);
% xlim([-100, 250]);
% ylim([-2, 5]);
% ylabel('velocity (\mum/min)', 'FontSize', 12);
% axis square;
% hold on;
% line([-100, 250], [0, 0], 'LineWidth', 2, 'LineStyle', '--');
% line([0, 0], [-2, 5], 'LineWidth', 2, 'LineStyle', '--'); 
% legend({'CK689','DMSO_CyD', 'DMSO_Bleb', 'DMSO_AICAR'});
% end
% saveas(gcf, fullfile(community_cluster_folder, ['Vel_clusters_K=' num2str(max(group_label)) 'certain_interval.fig']));
% 
% 
% % Step 6: draw the profile on the PC space 
% % in PC space.
% % draw_cluster_heatmap(label_DMSO, DMSO.PCA_score, [-1, 2], community_cluster_folder, 'DMSO-PCs-heatmap');
% % draw_cluster_heatmap(label_DMSO_CyD, DMSO_CyD.PCA_score, [-1, 2], community_cluster_folder, 'DMSO_CyD-PCs-heatmap');
% % draw_cluster_heatmap(label_CC, CC.PCA_score, [-1, 2], community_cluster_folder, 'CC-PCs-heatmap');
% close all;
