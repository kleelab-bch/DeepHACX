function [mean_pro, median_pro, lower_pro, upper_pro] = draw_confidence_interval_time_hetergeneity(data, name, event, color, lim_x)
%draw data_.
%
%
%SYNOPSIS draw_velocity(data_)
%
%INPUT      data_: the aligned speed based on the protrusion event.
%           
%OUTPUT     Figure.
data_ = data;
%check the size
[row, col] = size(data_);
%draw aligned velocity based on the protrusion event.
if row > 1
%1) calculate nan_mean
mean_pro = nanmean(data_);

%1.1) calculate nan_median
median_pro = nanmedian(data_);
%2) calculate nan_variance.
var_pro = nanstd(data_);
%3) since mean and standard deviation are both unknown, therefore,
%sample mean follows the t distribution with mean miu, and stadard
%deviation s/sqrt(n).
%For a population (less than 30) with unknown mean  and unknown standard deviation, a 
%confidence interval for the population mean, based on a simple random 
%sample (SRS) of size n, is   + t*, where t* is the upper (1-C)/2 
%critical value for the t distribution with n-1 degrees of freedom, 
%t(n-1).
if row > 30
    % the number of samples is greater than 30, we check the normal
    % distribution table, we know 95% confidence interval:1.96
    upper_pro = mean_pro + 1.96 * sqrt(var_pro)/sqrt(row);
    lower_pro = mean_pro - 1.96 * sqrt(var_pro)/sqrt(row);
        
else 
    % the number of samples is less than 30, we check the t distribution
    % table, for degree of freedom ( 5), alpha/2 0 0.025: 2.571
    upper_pro = mean_pro + 2.571 * sqrt(var_pro)/sqrt(row);
    lower_pro = mean_pro - 2.571 * sqrt(var_pro)/sqrt(row);
end

confplot(-200*5:5:200*5, mean_pro, lower_pro, upper_pro,'Color',color,'LineWidth',1);
% hold on
% plot(-200*5:5:200*5, median_pro, 'Color', [0,0,1], 'LineWidth', 2);
xlabel('time','FontName','Helvetica','FontSize',10);
ylabel(name,'FontName','Helvetica','FontSize',10);


if strcmp(name, 'velocity')
    ylim([-0.5, 3]);
else
    if strcmp(name, 'distance')
        ylim([-10, 60]);
    else
        ylim([100, 800]);
    end
end
xlim([0, 1000]);
%legend('95% confidence boundaries','mean');
title(event);
else
    mean_pro = [];
    median_pro = [];
    lower_pro = [];
    upper_pro = [];
end
   