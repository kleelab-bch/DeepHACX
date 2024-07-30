function  draw_cluster_heatmap(label, dminpoolv, Range, K_pathname, Experiment_type)
%Based on the label and the velocity, we will draw velocity profile on each
%cluster.
K_cluster = max(label);
figure
set(gcf, 'Position', get(0, 'Screensize'));
mean_pro = [];
lower_pro = [];
upper_pro = [];
for jj = 1 : K_cluster
    cluster_v = dminpoolv(find(label == jj),:);
    [row, col] = size(cluster_v);
    event = ['Clusters: ' num2str(jj) ' Size: ' num2str(row)];
    subplot(2,ceil(K_cluster/2),jj);
    if ~isnan(strfind(Experiment_type, 'Vel'))
        imagesc(cluster_v(:, 196:251), Range); 
    else
        imagesc(cluster_v, Range); 
    end
end
saveas(gcf, fullfile(K_pathname, [Experiment_type '-clusters_K=' num2str(K_cluster) 'certain_interval.fig']));
end