function [vel, boundary] = trim_outliers(data, save_folder, filename)
%remove some unexpected noises.
vel = data; 
[row, col] = size(data);
figure
imagesc(vel);
saveas(gcf, fullfile(save_folder, [filename, '_pre.fig']));
figure
[counts, centers] = hist(reshape(data, row*col, 1), 100);
bar(centers, counts);
ylim([0  5000]);
xlim([-20, 30]);
saveas(gcf, fullfile(save_folder, [filename, '_histogram.fig']));
prompt = 'What is the lower and upper boundary value?'
boundary = input(prompt);

[row_index, col_index] = find(data < boundary(1,1));
for i = 1 : length(row_index)
    vel(row_index(i,1), col_index(i, 1)) = NaN;
end

[row_index, col_index] = find(data > boundary(1,2));
for i = 1 : length(row_index)
    vel(row_index(i,1), col_index(i, 1)) = NaN;
end

figure
imagesc(vel);
saveas(gcf, fullfile(save_folder, [filename, '.fig']));
close all;
end

