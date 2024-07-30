function distance = calculate_distance(velocity_matrix)
%calculate distance based on the velocity

[row, col] = size(velocity_matrix);
distance = NaN(row, col);

for i = 1: row
    dist =[];
    %Calculate the distance for each sample
    each_row = velocity_matrix(i,:);
    sub_each_row = each_row(~isnan(each_row));
    for j = 1: length(sub_each_row)
        dist = [dist, trapz(sub_each_row(1:j))];
    end
    distance(i, ~isnan(each_row)) = dist;
end