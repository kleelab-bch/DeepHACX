function draw_figures_for_each_group(pathname, whole_dminpoolv)

   name_whole = {'PAA_196_end', 'PAA_201_end','pool_dminpoolv_normr_196_end', 'pool_dminpoolv_normr_201_end', 'symbolic_feat_data_196_end', 'symbolic_feat_data_201_end'};
   postfix = {'min_number', 'threshold_20', 'threshold_30', 'threshold_40', 'threshold_50', 'threshold_60'};
  for i = 1 : length(name_whole)
    for j = 1 : length(postfix)
        dist_s = load(fullfile(pathname, [name_whole{1,i},'_acf_distnormalized_ACF_truncated_', postfix{1,j}, '.mat']));
        new_pathname = fullfile(pathname, fullfile(name_whole{i}, postfix{1,j}));
        mkdir(new_pathname);
        field_name = fieldnames(dist_s);
        if length(field_name) == 1
           dist = getfield(dist_s, field_name{1});
        end
        for cl_K = 2
           %call density peaks
           K = cl_K;
           K_pathname = fullfile(new_pathname, num2str(K));
           mkdir(K_pathname);
           density_peaks(dist, K, K_pathname, [name_whole{i}, postfix{1,j}, num2str(K)]);
        
           %Read the marker and raw data.
           cl_name = 'cluster_assignment.mat';
           s_dist = load(fullfile(K_pathname, cl_name));
           cl = s_dist.cl;
        
           %Draw the clusters
           clusters = {};
           figure('visible', 'on')
           for k = 1 : K
               event = ['Cluster: ' num2str(k)];
               cluster_v = whole_dminpoolv(find(cl == k),:);
               subplot(1, K, k)
               [mean_pro, lower_pro, upper_pro] =  draw_confidence_interval(cluster_v, 'velocity', event);
               clusters{k} = cluster_v;
           end
           save(fullfile(K_pathname, ['clustersK=' num2str(K) '.mat']), 'clusters');
           saveas(gcf, fullfile(K_pathname, ['clusters_K=' num2str(K) '.fig']));
        
           %Draw Heat map
           %Heatmap
           figure
           for k = 1 : K
               subplot(1,K, k)
               cluster_v = whole_dminpoolv(find(cl == k), :);
               [ordered_sampleset, length_retraction_protrusion] = order_samples_by_length(cluster_v, 1);%order them by the length of protrusion event.
               imagesc(ordered_sampleset);
               xlabel('frame');
               ylabel('sample');
               event = ['Cluster: ' num2str(k)];
               title(event);
           end
           saveas(gcf, fullfile(K_pathname, 'sample_heatmap.fig'));
        
        
           %Draw time distribution
           figure
           for k = 1 : K
               subplot(1,K, k)
               cluster_v = whole_dminpoolv(find(cl == k), :);
               time_cluster = cluster_v(:, 201:end);
               time_cluster_frequency = sum(~isnan(time_cluster), 2);
               hist(time_cluster_frequency, max(time_cluster_frequency));
               xlabel('the length of time');
               ylabel('frequency');
               ylim([1 50]);
               event = ['Cluster: ' num2str(k)];
               title(event);  
           end
           saveas(gcf, fullfile(K_pathname, 'The distribution of the length of time.fig'));
        
          figure
          c_index = [];
          for ii = 1 : K
               ci_index = find(cl == ii);
               c_index = [c_index, ci_index];
          end
          dist_order = dist(c_index, c_index);
          imagesc(dist_order);
          title('order distance map');
          saveas(gcf, fullfile(K_pathname,'order_dist_heatmap.fig'));
    
         order_S = silhouette_by_defined_matrix(cl, dist, K);
         figure
         bar(1:length(order_S), order_S);
         saveas(gcf, fullfile(K_pathname, 'silhouette.fig'));
         %Draw 2D CMDS
         [Y] = cmdscale(dist);
         % Plot results
         gscatter(Y(:,1), Y(:,2), cl);
         title('2D CMDS plot');
         saveas(gcf, fullfile(K_pathname,'cMDS.fig'));
         save(fullfile(K_pathname,'cMDS.mat'), 'Y');
         
%          %%
%          %Draw Protein Activities
%          len = length(cl);
%         [row, col] = size(whole_dminpoolv);
%         if len ~= row
%             display('the number of the samples is not equal');
%             exit(0);
%         end
%         %Get the sample set for different protein.
%         labels = zeros(1, row);
%         names = {'Actin', 'Arp23', 'Cofilin1', 'VASP', 'Halo', 'mDia1', 'mDia2'};
%         for ii = 1 : len
%           %find the protein
%           for jj = 1 : length(names)
%              label = strfind(whole_dminpoolc{ii}, names{jj});
%              if label == 1
%                 labels(1,ii) = jj;
%                 break;
%              end
%           end     
%         end
%         save(fullfile(K_pathname, 'sample_label_for_different_proteins.mat'), 'labels');
%         %Draw different Intensity activities for different protein.
%         for jj = 1 : length(names)
%             label = find(labels == jj);
%             dminpool_j = whole_dminpool(label, :);
%             dminpoolv_j = whole_dminpoolv(label,:);
%             cl_j = cl(1, label);
%             clusters_Int = {};
%             clusters_vel = {};
%         
%            figure('visible', 'off')
%            for ii = 1 : K
%             event = ['Cluster: ' num2str(ii) ' ' names{jj}];
%             cluster_I = dminpool_j(find(cl_j == ii),:);
%             subplot(2, K, ii);
%             [mean_pro, lower_pro, upper_pro] =  draw_confidence_interval(cluster_I, 'Intensity', event);
%             clusters_Int{ii} = cluster_I;
%             subplot(2, K, K+ii);
%             cluster_v = dminpoolv_j(find(cl_j == ii),:);
%             [mean_pro, lower_pro, upper_pro] =  draw_confidence_interval(cluster_v, 'velocity', event);
%             clusters_vel{ii} = cluster_v;
%           end 
%           save(fullfile(K_pathname, [names{j} ' intensity_velocity_distance.mat']), 'clusters_Int', 'clusters_vel');
%           saveas(gcf, fullfile(K_pathname, [names{j} ' intensity_velocity_distance.fig']));
%         end
       end
    end
  end    
end

