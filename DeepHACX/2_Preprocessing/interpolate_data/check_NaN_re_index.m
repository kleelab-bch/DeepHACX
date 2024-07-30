function [flag, index] = check_NaN_re_index(dminpool_interpolate, dminpoolv_interpolate)
%%Check whether these two data contain NaN data.

[row, col] = size(dminpool_interpolate);
flag = 0;
index = [];
%%for dminpool data
for i = 1: row
    list_nonnan = find(~isnan(dminpool_interpolate(i,:)));
    l_index = min(list_nonnan);
    r_index = max(list_nonnan);
    for j = l_index:r_index
        if isnan(dminpool_interpolate(i,j))
            flag = 1;
            index = [index, i];
        end
    end
end

%%for dminpoolv data
for i = 1: row
    list_nonnan = find(~isnan(dminpoolv_interpolate(i,:)));
    l_index = min(list_nonnan);
    r_index = max(list_nonnan);
    for j = l_index:r_index
        if isnan(dminpoolv_interpolate(i,j))
            flag = 1;
            index = [index , i];
        end
    end
end

