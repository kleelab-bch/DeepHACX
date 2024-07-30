function draw_time_hetergeneity_protein(individual_group, dminpool_group, protein_group, protein_names)
%Here, the function implements to draw the protein activity for each group.

%Input: individual group: the cell data for this group
%        dminpool_group: Intensity for this group
%        protein_group: labels for each sample in this group
figure
%Draw the velocity
subplot(4,2,1);
draw_confidence_interval_time_hetergeneity(individual_group, 'velocity', 'velocity', [1,0,0]);
for i = 1 : length(protein_names)
    subplot(4,2,i+1);
    draw_confidence_interval_time_hetergeneity(dminpool_group(find(protein_group == i),:), 'Intensity', protein_names{1,i}, [1,0,0]);
end
end