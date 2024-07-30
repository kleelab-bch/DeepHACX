%evaluating the cluster results.
%load the distance.
Dist = load('dist_euclidean.mat');
dist = Dist.dist_matrix;
%%Cluster label.
ordered_cluster_label = load('ordered_cluster_label_K_800.mat');
group_label = ordered_cluster_label.ordered_cluster_label;
K_cluster = length(unique(group_label));

mkdir('Determination_K_800');
%draw order distance map
figure
c_index = [];
for ii = 1 : K_cluster
     ci_index = find(group_label == ii);
     c_index = [c_index, ci_index];
end
dist_order = dist(c_index, c_index);
imagesc(dist_order, [0, 2.5]);
title('ordered distance map');
xlabel('Sample Index');
ylabel('Sample Index');
set(gca, 'fontsize', 14);
saveas(gcf, fullfile('Determination_K_800','order_dist_heatmap.fig'));

close all;
S = silhouette_by_defined_matrix(group_label, dist, K_cluster);
save(fullfile('Determination_K_800','Silhouettevalue.mat'), 'S');
figure
bar(1:length(S), S);
saveas(gcf, fullfile('Determination_K_800', 'silhouette.fig'));

colormap = [253,187,132
215,48,31
236,231,242
166,189,219
54,144,192
129,15,124 ] / 255;
Left = 1;
figure
for Wang = 1 : K_cluster
    len = length(find(group_label == Wang));
    right = len + Left - 1;
    bar(Left:right, S(Left:right, 1), 'LineWid', 0.4, 'FaceColor', colormap(Wang,:), 'EdgeColor', colormap(Wang,:));
    title('Silhouette Map');
    Left = Left + len;
    hold on;
end
xlim([0, 8750]);
xlabel('Sample Index', 'fontname', 'Arial', 'fontsize', 14);
ylabel('Silhouette Value', 'fontname', 'Arial', 'fontsize', 14);
title('Silhouette Evaluation', 'fontname', 'Arial', 'fontsize', 16);
set(gca, 'fontname', 'Arial', 'fontsize', 14);
saveas(gcf, fullfile('Determination_K_800', 'silhouette_colored.fig'));
    
% %draw the MDS
% [Y] = cmdscale(dist);
% %Plot results
% figure
% gscatter(Y(:,1), Y(:,2), group_label);
% title('CMDS plot');
% xlabel('MD1');
% ylabel('MD2');
% xlim([-1.5, 1.5]);
% ylim([-1.5, 1.5]);
% set(gca, 'fontsize', 14);
% saveas(gcf, fullfile('Determination_K_800', 'CMDS.fig'));

%
% addpath(genpath('./tSNE'));
% Visualization
load('ACF_longer_sample.mat');
%Draw tSNE
no_dims = 2;
initial_dims = 13;
perplexity = 30;
mappedx = tsne(ACF_longer_sample, [], no_dims, initial_dims, perplexity);
save(fullfile('Determination_K_800', 'tNSE_15_30.mat'), 'mappedx');
%folder = '../01-19-2020-Umap/ACF'
%DMSO_survivin = load(fullfile(folder, 'Umap_embedding_ACF_13.mat'));
%mappedx = DMSO_survivin.embedding;
figure
gscatter(mappedx(:,1), mappedx(:,2), group_label, colormap, '.'); %group_label
title('tSNE Deep Features');
xlabel('tSNE1');
ylabel('tSNE2');
set(gca, 'fontsize', 14);
axis square;
saveas(gcf, fullfile('Determination_K_800', 'tSNE_cluster7_v2.fig'));


