%order the heatmap sample.
function leafOrder = order_sampls_hclustering(data)
    protrusion_data = data(:, 201:end);
    [row, col] = size(protrusion_data);
    %find the minimus length of samples.
    rowSum = sum(~isnan(protrusion_data), 2);
    len_row = min(rowSum);
    
    %used for H_clustering.
    h_data = data(:, 201:201+len_row-1);
    h_dist = pdist(h_data, 'euclidean');
    h_tree = linkage(h_dist, 'ward');
    leafOrder = optimalleaforder(h_tree, h_dist, 'Criteria', 'adjacent', 'Transformation', 'inverse');
    
    %plot the figure
%     figure()
%     subplot(2,1,1)
%     dendrogram(h_tree, 0)
%     title('Default Leaf Order')
% 
%     subplot(2,1,2)
%     dendrogram(h_tree, 0, 'reorder',leafOrder)
%     title('Optimal Leaf Order')
end