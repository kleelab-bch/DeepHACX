function [dminpool_int, dminpoolv_int] = interpolate_data(pool, poolv)
%%
%interpolate the missing data.

%get the row and column of data.
[row_v, col_v] = size(poolv);
[row, col] = size(pool);
dminpool_int = pool;
dminpoolv_int = poolv;

if row_v == row & col_v == col
    %Check the data whether there is a data that is NaN.
    for i = 1: row_v
        %get the first and last index of non-NaN data.
        list_nonnan = find(~isnan(poolv(i,:)));
        l_index = min(list_nonnan);
        r_index = max(list_nonnan);
        for j = l_index+1:r_index-1
            %if the data(i,j) is NaN, we should interpolate it. 
            if isnan(poolv(i, j))
                dminpoolv_int(i,j) = interpolate_method(poolv(i,:), j, l_index, r_index);
            end   
        end
        
        list_nonnan = find(~isnan(pool(i,:)));
        l_index = min(list_nonnan);
        r_index = max(list_nonnan);
        for j = l_index+1:r_index-1
            %if the data(i,j) is NaN, we should interpolate it. 
            if isnan(pool(i, j))
                dminpool_int(i,j) = interpolate_method(pool(i,:), j, l_index, r_index);
            end   
        end
    end
else
    disp('the size of these two matrix does not match');
end