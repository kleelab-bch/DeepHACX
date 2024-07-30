function effect_size = calculate_effect_size(population1, population2)
%In this function, we will estimate the effect size based on control and
%treatment experiment following the equations:
%effect_size = (mean1 - mean2)/estimated_std;
%estimated_std = sqrt(((n1-1)*var1 + (n2-1)*var2)/ (n1 + n2 - 2)).

%calcualte the mean and variance values.
mean1 = nanmean(population1);
mean2 = nanmean(population2);

var1 = nanvar(population1);
var2 = nanvar(population2);

n1 = length(~isnan(population1));
n2 = length(~isnan(population2));

%estimated std.
estimated_std = sqrt(((n1-1)*var1 + (n2-1)*var2)/ (n1 + n2 - 2));

effect_size = (mean1 - mean2) / estimated_std;

end