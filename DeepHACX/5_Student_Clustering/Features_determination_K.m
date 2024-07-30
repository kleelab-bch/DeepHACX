
% Step 1: load the data
load('truncated_dataset.mat');

%%
saved_folder = 'Evaluation_K';
mkdir(saved_folder);
%% Evaluation
eva = evalclusters(PCA_score_truncated,'gmdistribution','silhouette','KList',[1:20]);
figure
plot(2:20, eva.CriterionValues(2:20), '-*');
title('silhouette value');

xlabel('#Clusters');
ylabel('Silhouette Value');
set(gca, 'fontsize', 14);
saveas(gcf, fullfile(saved_folder, 'Silhouette_value_GMM.fig'));

% silhouette_value = NaN(19, 1);
% Avg_silhouette_value  = NaN(19, 1);
% for i = 2 : 20
%     Avg_silhouette_value(i-1, 1) = sum(eva.ClusterSilhouettes{1, i}) / i;
%     silhouette_value(i-1, 1) = sum(eva.ClusterSilhouettes{1, i});
% end
% figure
% plot(2:20, silhouette_value, '-*');
% title('silhouette value');
% 
% xlabel('#Clusters');
% ylabel('Silhouette Value');
% set(gca, 'fontsize', 14);
% saveas(gcf, fullfile(saved_folder, 'Silhouette_value.fig'));
% 
% figure
% plot(2:20, Avg_silhouette_value, '-*');
% title('Avg silhouette value');
% 
% xlabel('#Clusters');
% ylabel('Avg Silhouette Value');
% set(gca, 'fontsize', 14);
% saveas(gcf, fullfile(saved_folder, 'Avg_Silhouette_value.fig'));

eva_DBI = evalclusters(PCA_score_truncated,'gmdistribution','DaviesBouldin','KList',[1:20]);
figure
plot(2:20, eva_DBI.CriterionValues(2:20), '-*');
title('DBI value');
xlabel('#Clusters');
ylabel('DBI Value');
set(gca, 'fontsize', 14);
saveas(gcf, fullfile(saved_folder, 'DBI_value_GMM.fig'));

% eva_CH = evalclusters(PCA_score,'kmeans','CalinskiHarabasz','KList',[1:20]);
% figure
% plot(2:20, eva_CH.CriterionValues(2:20), '-*');
% axis square
% title('CalinskiHarabasz value');
% xlabel('#Clusters');
% ylabel('CalinskiHarabasz Value');
% set(gca, 'fontsize', 14);
% saveas(gcf, fullfile(saved_folder, 'CalinskiHarabasz.fig'));
% 
% figure
% yyaxis left
% plot(2:10, eva.CriterionValues(2:10), '-*');
% hold on;
% yyaxis right
% plot(2:10, eva_CH.CriterionValues(2:10), '-*');
% axis square
