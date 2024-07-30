function [mean_pro, lower_pro, upper_pro] = draw_cluster_profile(label, dminpoolv, K_pathname, Experiment_type)
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
    subplot(2, ceil(K_cluster/2),jj);
         
    [mean_p, lower_p, upper_p] =  draw_confidence_interval_time_bootci(cluster_v, 'velocity (\mum/min)', event); 
    axis square;
    mean_pro(jj, :) = mean_p;
    lower_pro(jj, :) = lower_p;
    upper_pro(jj, :) = upper_p;
end
saveas(gcf, fullfile(K_pathname, [Experiment_type '-clusters_K=' num2str(K_cluster) 'certain_interval.fig']));
end