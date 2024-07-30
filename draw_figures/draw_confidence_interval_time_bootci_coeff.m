function [mean_p, upper_p, lower_p] = draw_confidence_interval_time_bootci(data, name, event, color_map)
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
confplot(-350:5:350, mean_p, lower_p, upper_p, 'Color', color_map, 'LineWidth', 1);%[1,0,0]
xlabel('time', 'FontName', 'Helvetica', 'FontSize', 10);
ylabel(name, 'FontName', 'Helvetica', 'FontSize', 10);
if strcmp(name, 'velocity')
    ylim([-2, 4]);
    
else
    if strcmp(name, 'distance')
        ylim([-10, 60]);
    else
        if strcmp(name, 'intensity')
            ylim([200, 600]);
        else
            ylim([-1,1]);
        end
    end
end
xlim([-350, 350]);
title(event);
end
end