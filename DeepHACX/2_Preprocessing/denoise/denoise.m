function [denoise_distance, poolv] = denoise(path, poolv)
%denoise for the interpolated data.
%pathname = '../2015-10-22-Interpolate_data/arp23_dminpoolv_interpolate.mat';
% pathname = fullfile(path, [name postfix]);
% %Arp23 velocity
% poolv_s = load(pathname);
% poolv = poolv_s.dminpoolv_interpolate; 
%here for layer2 we should use the following row.
%dminpoolv = dminpoolv_s.dminpoolv_layer2_interpolate; 

[row, col] = size(poolv);
distance = calculate_distance(poolv);
%set the distance[:, 201] = 0;

%Set the middle frame is zero
for i = 1: row
    distance(i,:) = distance(i,:) - distance(i, 201);
end
filename = 'all_distance_predenoise.mat';
save(fullfile(path, filename), 'distance'); 

denoise_distance = NaN(row, col);
for i = 1: row
    tic
    
    each_row = distance(i,:);
    %figure;
    %plot(each_row);
    %trim the rows which contains NaN values.
    sub_each_row = each_row(~isnan(each_row));
    denoise_b = emd_dfadenoising(sub_each_row);
    %figure;
    each_row_denoise = distance(i,:);
    each_row_denoise(~isnan(each_row)) = denoise_b;
    denoise_distance(i, ~isnan(each_row)) = denoise_b;
    %plot(each_row_denoise);
    toc
end
filename = 'all_distance_denoise.mat';
save(fullfile(path, filename), 'denoise_distance');