function [mean_p, upper_p, lower_p] = draw_confidence_interval_bootci(data, name, event)
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

%draw the mean and confidence interval
if row >= 3
confplot(201 - floor(col/2): 1 :201 + floor(col/2), mean_p, lower_p, upper_p, 'Color', [1,0,0], 'LineWidth', 1);
%confplot(1:1:length(mean_p), mean_p, lower_p, upper_p, 'Color', [1,0,0], 'LineWidth', 1);
xlabel('Frame', 'FontName', 'Helvetica', 'FontSize', 10);
ylabel(name, 'FontName', 'Helvetica', 'FontSize', 10);
if strcmp(name, 'velocity (\mum/min)')
    ylim([-2, 4]);
    xlim([1, 401]);

else
    if strcmp(name, 'distance')
        ylim([-10, 60]);
    else
        ylim([200, 650]);
        xlim([1, 401]);
    end
end
title(event);
end
end

