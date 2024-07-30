function draw_time_hetergeneity(cells_dataset, boundary, LowY, HighY)
%In this function, the figure will be drew to show mean or median value
%with confidence interval.

%Input: cells_dataset: cells contain different groups based on the length
%of time. And the length of time is increasing stored in the input.
cell_num = length(cells_dataset);
cc=hsv(12);

for i = 1 : cell_num
    figure
    [mean_pro, median_pro, lower_pro, upper_pro] = draw_confidence_interval_time_hetergeneity(cells_dataset{i,1}, 'velocity', ['group ' num2str(i)], cc(i,:));
    hold on;
    if i < cell_num
        line([boundary(i,1)*5, boundary(i,1)*5], [LowY, HighY]);
    end
    hold on;
end

end