%Draw the protein activity.

    pathname = '../results/SAX';
    K = 4;

    foldername = fullfile(pathname, ['normr_acf/' num2str(K)]);

    cl_name = 'dminpoolv_f_dist_196_251_normr_dist_acf_for_all_factorscluster_assignment.mat';
    s_dist = load(fullfile(foldername, cl_name));
    cl = s_dist.cl;
    
%     dminpool_less_56 = load(fullfile(pathname, 'dminpool_less_56.mat'));
%     dminpoolv = dminpool_less_56.dminpool_less_56.dminpoolv_f_dist;
%     dminpool = dminpool_less_56.dminpool_less_56.dminpool;
%     dminpoold = dminpool_less_56.dminpool_less_56.dminpoold;
%     dminpoolc = dminpool_less_56.dminpool_less_56.dminpoolc;

    symbolic_dataset = load(fullfile(pathname,'symbolic_dataset.mat'));
    symbolic_dataset = symbolic_dataset.symbolic_dataset;
    dminpoolv = symbolic_dataset.dminpoolv_f_dist;
    dminpool = symbolic_dataset.dminpool;
    dminpoold = symbolic_dataset.dminpoold;
    dminpoolc = symbolic_dataset.dminpoolc;


    len = length(cl);
    [row, col] = size(dminpoolv);
    if len ~= row
        display('the number of the samples is not equal');
        exit(0);
    end
    %Get the sample set for different protein.
    labels = zeros(1, row);
    names = {'Actin', 'Arp23', 'Cofilin1', 'VASP', 'Halo', 'mDia1', 'mDia2'};
    for i = 1 : len
        %find the protein
        for j = 1 : length(names)
            label = strfind(dminpoolc{i}, names{j});
            if label == 1
                labels(1,i) = j;
                break;
            end
        end     
    end
    save(fullfile(foldername, 'sample_label_for_different_proteins.mat'), 'labels');
    %Draw different Intensity activities for different protein.
    for j = 1 : length(names)
        label = find(labels == j);
        dminpool_j = dminpool(label, :);
        dminpoolv_j = dminpoolv(label,:);
        dminpoold_j = dminpoold(label,:);
        cl_j = cl(1, label);
        clusters_Int = {};
        clusters_vel = {};
        clusters_dist = {};
        figure
        for i = 1 : K
            event = ['Cluster: ' num2str(i) ' ' names{j}];
            cluster_I = dminpool_j(find(cl_j == i),:);
            subplot(3, K, i);
            [mean_pro, lower_pro, upper_pro] =  draw_confidence_interval(cluster_I, 'Intensity', event);
            clusters_Int{i} = cluster_I;
            subplot(3, K, K+i);
            cluster_v = dminpoolv_j(find(cl_j == i),:);
            [mean_pro, lower_pro, upper_pro] =  draw_confidence_interval(cluster_v, 'velocity', event);
            clusters_vel{i} = cluster_v;
            subplot(3, K, 2*K + i);
            cluster_d = dminpoold_j(find(cl_j == i), :);
            clusters_dist{i} = cluster_d;
            [mean_pro, lower_pro, upper_pro] =  draw_confidence_interval(cluster_d, 'distance', event);
        end 
        save(fullfile(foldername, [names{j} ' intensity_velocity_distance.mat']), 'clusters_Int', 'clusters_vel', 'clusters_dist');
        saveas(gcf, fullfile(foldername, [names{j} ' intensity_velocity_distance.fig']));
    end