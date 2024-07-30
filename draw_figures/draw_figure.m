%This function draws all the figures related to the results.
%
%Here, there are several figures
%1: The mean and confidence interval figure including velocity,
%acf(Periodogram), SAX. And the imagesc heapmap.

%2: Density Map, cluster layered structure, silhouette map, Distance map,
%2D CMDs

%3: Protein Activity.

%4: Movies back to images
function draw_figure()
%Parameters:
    pathname = '../results/SAX';
    folder = 'Euclidean_PAA';
    name = 'dminpoolv_f_dist_196_251_PAA_dist_euclidean_for_all_factors.mat';
    mkdir(pathname, folder);
    
    dist_s = load(fullfile(pathname, name));
    field_name = fieldnames(dist_s);
    if length(field_name) == 1
        dist = getfield(dist_s, field_name{1});
    end
%Density Peaks   
    K = 6;
    K_pathname = fullfile(fullfile(pathname, folder), num2str(K));
    mkdir(K_pathname);
    density_peaks(dist, K, K_pathname, strtok(name, '.'));
%Velocity/ ACF mean and confidence Interval.

    %Read the marker and raw data.
%     K = 8;
%     K_pathname = fullfile(fullfile(pathname, folder), num2str(K));
    cl_name = [strtok(name, '.') 'cluster_assignment.mat'];
    %cl_name = 'PAA_ratio_2_alpha_size_4_normalized_ACF_truncated_min_numbercluster_assignment.mat';
    s_dist = load(fullfile(K_pathname, cl_name));
    cl = s_dist.cl;
    
    dminpool_more_56 = load(fullfile(pathname, 'dminpoolv_196_251.mat'));
    dminpoolv = dminpool_more_56.dminpoolv_f_dist;
    
    dminpoolv_more_56_normr_s = load(fullfile(pathname, 'dminpoolv_f_dist_196_251_normr.mat'));
    dminpoolv_less_56_normr = dminpoolv_more_56_normr_s.dminpoolv_f_dist_196_251_normr;
    
%     acf_coefficient_s = load(fullfile(pathname, 'dminpoolv_f_dist_normr_normalized_acf_all_samples.mat'));
%     acf_coefficient = acf_coefficient_s.normalized_acf;
%     
    clusters = {};
    figure
    for j = 1 : K
    
        %i = K_list(j);
        i = j;
        event = ['Cluster: ' num2str(i)];
     
        cluster_v = dminpoolv(find(cl == i), :);
    
        subplot(3, K, j)
        [mean_pro, lower_pro, upper_pro] =  draw_confidence_interval(cluster_v, 'velocity', event);
        clusters{i} = cluster_v;
        
        subplot(3, K, K + j);
        sym_cluster_v = dminpoolv_less_56_normr(find(cl == i), :);
        %sym_cluster_v_rep = repelem(sym_cluster_v,1,4);
        draw_confidence_interval_sym(sym_cluster_v, 'normalized velocity', event);
%         
%         subplot(3, K, 2*K + j);
%         acf_coefficient = acf_coefficient(find(cl == i), :);
%         %sym_cluster_v_rep = repelem(sym_cluster_v,1,4);
%         draw_confidence_interval_acf(acf_coefficient(:,1:13), 'ACF coefficient', event);
    end
    save(fullfile(K_pathname, ['clusters_in_less_56_K=' num2str(K) '.mat']), 'clusters');
    saveas(gcf, fullfile(K_pathname, ['clusters_in_the_whole_data_K=' num2str(K) '.fig']));
    
end
