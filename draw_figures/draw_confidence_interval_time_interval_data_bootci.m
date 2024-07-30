function [mean_p, upper_p, lower_p] = draw_confidence_interval_time_interval_data_bootci(data, name, event)
%draw data_

%check the size
[row, col] = size(data);
data_ = data;
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
confplot(-100:5:(col-20-1) * 5, mean_p, lower_p, upper_p, 'Color', [1,0,0], 'LineWidth', 1);
xlabel('time(s)', 'FontName', 'Helvetica', 'FontSize', 10);
ylabel(name, 'FontName', 'Helvetica', 'FontSize', 10);
if strcmp(name, 'velocity (nm/min)')
    ylim([-2, 4]);
    
else
    if strcmp(name, 'distance')
        ylim([-10, 60]);
    else
        ylim([200, 600]);
    end
end
xlim([-100, 300]);
title(event);
end
end