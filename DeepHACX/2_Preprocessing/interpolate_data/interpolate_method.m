function data_j = interpolate_method(data, j, l_index, r_index)
%%
%interpolate the data at the location j.
%for actin, we use 9 interval.
if j > l_index & j < r_index
    %data_j = interp1(l_index:j-1, data(l_index:j-1), j);
    %Here we use the nearest at most 7 data to interpolate the current
    %value.
    if j - l_index >=4 
        if r_index- j >= 4
            temp_data = data(j-4:j+4);
            l_nonnan = find(~isnan(temp_data));
            data_j = sum(temp_data(l_nonnan))/length(l_nonnan);
        else
            temp_data = data(j-4: r_index);
            l_nonnan = find(~isnan(temp_data));
            data_j = sum(temp_data(l_nonnan))/length(l_nonnan);
        end
    else
        if r_index - j >= 4
            temp_data = data(l_index: j+4);
            l_nonnan = find(~isnan(temp_data));
            data_j = sum(temp_data(l_nonnan))/length(l_nonnan);
        else
            temp_data = data(l_index: r_index);
            l_nonnan = find(~isnan(temp_data));
            data_j = sum(temp_data(l_nonan))/length(l_nonnan);
        end
    end
        
else
    disp('the NaN data location should be between l_index and r_index');
end