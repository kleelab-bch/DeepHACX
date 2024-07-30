function draw_boundary(boundary, LowY, HighY)
%plot the vertical lines in the figure to show the boundary.

num_boundary = length(boundary);

for i = 1 : num_boundary
    line([boundary(i,1)*5, boundary(i,1)*5], [LowY, HighY]);
    hold on;
end
end