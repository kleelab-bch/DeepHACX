function [mean_p, upper_p, lower_p] = confidence_interval_bootci(data)
%draw data_

data_ = data;
%check the size
[row, col] = size(data_);

for k = 1 : col
    l = 1;
    for j = 1 : row
        if isnan(data_(j,k)) == 0
            y1nonan(l) = data_(j,k);
            l = l + 1;
        end
    end
    
    if l < 3
        ci_aligned(:,k) = [NaN, NaN];
        mean_aligned(k) = NaN;
    else
        ci_aligned(:,k) = bootci(1000, @mean, y1nonan);
        mean_aligned(k) = mean(y1nonan);
    end
    clear y1nonan;
end
mean_p = mean_aligned;
upper_p = ci_aligned(2,:);
lower_p = ci_aligned(1,:);
end

