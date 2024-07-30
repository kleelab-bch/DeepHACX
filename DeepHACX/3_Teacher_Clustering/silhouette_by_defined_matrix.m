function order_S = silhouette_by_defined_matrix(assign_C_0, dist, K)
%in this function, we try to get the silhouette value using our defined
%matrix.
[N, N] = size(dist);
S = NaN(N, 1);
for i = 1 : N
    %calculate the average distance between i and all other
    %observations in the same cluster.
    label = assign_C_0(1,i);
    Same_obser = find(assign_C_0 == label);
    Same_distance = dist(Same_obser, i);
    a_i = sum(Same_distance)/(length(Same_obser) - 1);
    
    %calculate the average distance between i and the observations in the
    %"nearest neighboring cluster"
    b_i = inf;
    for j = 1 : K
        if j ~= label
            l2 = find(assign_C_0 == j);
            l2_dist = dist(l2, i);
            temp_b_i = sum(l2_dist)/(length(l2));
            if temp_b_i < b_i
                b_i = temp_b_i;
            end
        end
    end
    S(i,1) = (b_i - a_i)/max(b_i, a_i);
end
 
%Draw the figure.
order_S = NaN(N, 1);
num_index = 1
for j = 1 : K
    label = find(assign_C_0 == j);
    S_j = S(label, 1);
    [order_S_j, index] = sort(S_j, 'descend');
    order_S(num_index:length(order_S_j) + num_index - 1, 1) = order_S_j;
    num_index = num_index + length(order_S_j);
end


