    pathname = '../results/less_56';
    K = 5;

    %foldername = fullfile(pathname, ['raw_data/threshold_30/' num2str(K)]);
    foldername = fullfile(pathname, ['SAX/ra_2_al_4/threshold_10/' num2str(K)]);

    cl_name = 'symbolic_feat_data_ratio_2_alpha_size_4_normalized_ACF_truncated_10cluster_assignment.mat';
    s_dist = load(fullfile(foldername, cl_name));
    cl = s_dist.cl;
    
    dminpool_less_56 = load(fullfile(pathname, 'dminpool_less_56.mat'));
    dminpoolv = dminpool_less_56.dminpool_less_56.dminpoolv_f_dist;
    
    %Heatmap
    figure
    for j = 1 : K
        subplot(1,K, j)
        cluster_v = dminpoolv(find(cl == j), :);
        imagesc(cluster_v);
        xlabel('frame');
        ylabel('sample');
        event = ['Cluster: ' num2str(j)];
        title(event);
    
    end
    saveas(gcf, fullfile(foldername, 'symbolic_feat_data_ratio_2_alpha_size_4_normalized_ACF_truncated_10heatmap.fig'));
    
    %Time distribution
    figure
    for j = 1 : K
        subplot(1,K, j)
        cluster_v = dminpoolv(find(cl == j), :);
        time_cluster = cluster_v(:, 201:251);
        time_cluster_frequency = sum(~isnan(time_cluster), 2);
        hist(time_cluster_frequency, max(time_cluster_frequency));
        xlabel('the length of time');
        ylabel('frequency');
        ylim([1 50]);
        event = ['Cluster: ' num2str(j)];
        title(event);
%         subplot(2,K, K + j)
%         time_cluster_frequencey_normalized = time_cluster_frequency / size(time_cluster, 1);
%         hist(time_cluster_frequency, max(time_cluster_frequency));
%         xlabel('the length of time');
%         ylabel('normalized frequency');
%          ylim([1 50]);
    
    end
    saveas(gcf, fullfile(foldername, 'The distribution of the length of time.fig'));
    
    
    %Draw the Distance Map and Sihoute Map
    
    dist_s = load(fullfile(pathname,'symbolic_feat_data_ratio_2_alpha_size_4_normalized_ACF_truncated_10.mat'));
    field_name = fieldnames(dist_s);
    if length(field_name) == 1
        dist = getfield(dist_s, field_name{1});
    end
    figure
    imagesc(dist);
    title('distance map');
    saveas(gcf, fullfile(foldername, 'distance map.fig'));
    c_index = [];
    for i = 1 : K
        ci_index = find(cl == i);
        c_index = [c_index, ci_index];
    end
    dist_order = dist(c_index, c_index);
    imagesc(dist_order);
    title('order distance map');
    saveas(gcf, fullfile(foldername,'order_dist_heatmap.fig'));
    
    order_S = silhouette_by_defined_matrix(cl, dist, K);
    figure
    bar(1:1659, order_S);
    saveas(gcf, fullfile(foldername, 'silhouette.fig'));
    %Draw 2D CMDS
    [Y] = cmdscale(dist);
    % Plot results
    gscatter(Y(:,1), Y(:,2), cl);
    title('2D CMDS plot');
    saveas(gcf, fullfile(foldername,'cMDS.fig'));
    save(fullfile(foldername,'cMDS.mat'), 'Y');