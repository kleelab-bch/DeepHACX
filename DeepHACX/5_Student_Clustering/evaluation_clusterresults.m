%evaluating the cluster results.
%load the distance.
Dist = load('dist_truncated.mat');
dist = Dist.Dist_DeepFeature_truncated;
%%Cluster label.
ordered_cluster_label = load('ordered_CK689_CK666_K_truncated_230_community.mat');
group_label = ordered_cluster_label.ordered_cluster_label;
K_cluster = length(unique(group_label));

mkdir('Determination_K_230');
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
saveas(gcf, fullfile('Determination_K_230','order_dist_heatmap.fig'));

close all;
S = silhouette_by_defined_matrix(group_label, dist, K_cluster);
save(fullfile('Determination_K_230','Silhouettevalue.mat'), 'S');
figure
bar(1:length(S), S);
saveas(gcf, fullfile('Determination_K_230', 'silhouette.fig'));
figure
% colormap = [94    79   162
%     50   136   189
%    102   194   165
%    171   221   164
%    320   245   152
%    255   255   191
%    254   224   139
%    253   174    97
%    244   109    67
%    213    62    79
%    158     1    66  ] / 255;

colormap = [27,158,119
217,95,2
117,112,179
231,41,138
102,166,30
32,171,2
166,118,29] / 255;
Left = 1;
for Wang = 1 : K_cluster
    len = length(find(group_label == Wang));
    right = len + Left - 1;
    bar(Left:right, S(Left:right, 1), 'LineWid', 0.4, 'FaceColor', colormap(Wang,:), 'EdgeColor', colormap(Wang,:));
    title('Silhouette Map');
    Left = Left + len;
    hold on;
end
saveas(gcf, fullfile('Determination_K_230', 'silhouette_colored.fig'));
    
%draw the MDS
[Y] = cmdscale(dist);
%Plot results
figure
gscatter(Y(:,1), Y(:,2), group_label);
title('CMDS plot');
xlabel('MD1');
ylabel('MD2');
xlim([-1.5, 1.5]);
ylim([-1.5, 1.5]);
set(gca, 'fontsize', 14);
saveas(gcf, fullfile('Determination_K_230', 'CMDS.fig'));

%
% addpath(genpath('./tSNE'));
load('truncated_dataset.mat');
% Visualization
%Draw tSNE
% no_dims = 2;
% initial_dims = 15;
% perplexity = 30;
% mappedx = tsne(PCA_score_truncated, [], no_dims, initial_dims, perplexity);
% save(fullfile('Determination_K_230', 'tNSE_15_30.mat'), 'mappedx');
load(fullfile('Determination_K', 'tNSE_15_30.mat'));
figure
gscatter(mappedx(:,1), mappedx(:,2), group_label, colormap, '.');
title('tSNE Deep Features');
xlabel('tSNE1');
ylabel('tSNE2');
xlim([-150, 150]);
ylim([-100, 100]);
set(gca, 'fontsize', 14);
axis square;
saveas(gcf, fullfile('Determination_K_230', 'tSNE.fig'));

%Draw tSNE separately.
CK689_length = length(find(Exper_label_truncated == 1));
CK666_length = length(find(Exper_label_truncated == 2));
CK689_mappedx = mappedx(1:CK689_length, :);
CK689_cluster_label = group_label(1:CK689_length);
figure
gscatter(CK689_mappedx(:,1), CK689_mappedx(:,2), CK689_cluster_label, colormap, '.');
title('CK689 tSNE Deep Features');
xlabel('tSNE1');
ylabel('tSNE2');
xlim([-150, 150]);
ylim([-100, 100]);
set(gca, 'fontsize', 14);
axis square;
saveas(gcf, fullfile('Determination_K_230', 'tSNE_CK689.fig'));

CK666_mappdex = mappedx(1+CK689_length:end,:);
CK666_cluster_label = group_label(1+CK689_length:end);
figure
gscatter(CK666_mappdex(:,1), CK666_mappdex(:,2), CK666_cluster_label, colormap, '.');
title('CK666 tSNE Deep Features');
xlabel('tSNE1');
ylabel('tSNE2');
xlim([-150, 150]);
ylim([-100, 100]);
set(gca, 'fontsize', 14);
axis square;
saveas(gcf, fullfile('Determination_K_230', 'tSNE_CK666.fig'));

%downsample
y = randsample(1:CK689_length, CK666_length);
figure
gscatter(CK689_mappedx(y,1), CK689_mappedx(y,2), CK689_cluster_label(y), colormap, '.');
title('CK689 tSNE Deep Features');
xlabel('tSNE1');
ylabel('tSNE2');
xlim([-150, 150]);
ylim([-100, 100]);
set(gca, 'fontsize', 14);
axis square;
saveas(gcf, fullfile('Determination_K_230', 'tSNE_downsample_CK689.fig'));


outCK689 = scatplot_v2(CK689_mappedx(y,1), CK689_mappedx(y,2), 'circles');
outCK666 = scatplot_v2(CK666_mappdex(:,1), CK666_mappdex(:,2), 'circles');

visualize_gsp(outCK689, outCK666, outCK666, 10, {'CK689', 'CK666', 'CK666'});
