function [cells_time_hetergeneity, group_label] = generate_time_hetergenerty_data(dminpoolv, boundary)
%In this function,the velocity dataset can be divided into several group
%based on the length of the whole protrusion event.

%The number of cluster.
number_of_cluster = length(boundary) + 1;
[row, col] = size(dminpoolv);
group_label = zeros(row, 1);
boundary_app = [0; boundary; inf];
%calculate the length of protrusion event of the dataset
length_protrusion_event = sum(~isnan(dminpoolv(:,201:end)), 2);

%create the cells
cells_time_hetergeneity = cell(number_of_cluster, 1);
for i = 1 : number_of_cluster
    cells_time_hetergeneity{i,1} = dminpoolv(find(length_protrusion_event > boundary_app(i) & length_protrusion_event <= boundary_app(i+1)),:);
end

%generate the label for each sample
for i = 1 : row
    group_label(i,1) = sum(boundary_app < length_protrusion_event(i,1), 1);
end

%Draws the figure 

end