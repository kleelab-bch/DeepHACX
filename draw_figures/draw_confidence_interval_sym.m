function draw_confidence_interval(data, name, event)
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
%1) calculate nan_mean
mean_pro = nanmean(data_);
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

confplot(-25:5:245, mean_pro(1:55), lower_pro(1:55), upper_pro(1:55),'Color',[1 0 0],'LineWidth',2);
xlabel('time','FontName','Helvetica','FontSize',10);
ylabel(name,'FontName','Helvetica','FontSize',10);
% if strcmp(name, 'velocity')
%     ylim([-2,4])
% else
%     ylim([350 550])
% end


xlim([-250 250]);
ylim([-1 1]);
%ylim([min(lower_pro(:)) max(upper_pro(:))]);
% if isempty(findstr(name, 'velocity'))
%     %ylim([min(lower_pro) max(upper_pro)])
%     if isempty(findstr(name, 'distance'))
%         if isempty(findstr(name, 'acceleration'))
%             ylim([300 600])%intensity
%         else%acceleration
%             ylim([-0.5 0.5])
%         end
%     else %distance
%         ylim([-5 60]) 
%        
%     end
% else %velocity
%     ylim([-1.5 2.5])
% end
%legend('95% confidence boundaries','mean');
title(event);
   