%estimate the avearge silhouette value.
mkdir('Determination_K');

Dist = load('dist_euclidean.mat');
dist = Dist.dist_matrix;

filenames = dir('DMSO_total_*_truncated_community.mat');
Results = NaN(length(filenames), 3);
for j = 1 : length(filenames)
    %%Cluster label.
    temp_name = filenames(j, 1).name;
    load(filenames(j, 1).name);
    group_label = zeros(1, length(cluster_label));
    for i = 1 : length(cluster_label)
        group_label(1, i) = str2num(cluster_label{i, 1});
    end
    K_cluster = length(unique(group_label));
    S = silhouette_by_defined_matrix(group_label, dist, K_cluster);   
    Results(j, 1) = K_cluster;
    Results(j, 2) = nanmean(S);
    %Results(j, 3) = str2num(temp_name(1:length(filenames(j, 1).name) - 34));
    Results(j, 3) = str2num(temp_name(length('DMSO_total_ '):length(temp_name) -24) );
end

B = sortrows(Results,3);
figure
yyaxis left
plot(B(:, 3), B(:, 2), '-*', 'LineWidth', 2);
ylabel('Silhouette Value');
set(gca, 'fontsize', 14);
yyaxis right
plot(B(:, 3), B(:, 1), '-o', 'LineWidth', 2);
ylabel('#Clusters');
xlabel('#Nearest samples');
set(gca, 'fontsize', 14);
saveas(gcf, fullfile('Determination_K', 'Avg_silhouette_of_clusters.fig'));