%calculate_effect_size_per_cluster.
K_cluster = 5;
effect_size  = NaN(K_cluster, 1);
default_bins = 80;
saved_folder = 'bootstrap_distribution';
mkdir(saved_folder);
for i = 1 : K_cluster
    load(['bootstate_value_' num2str(i) '.mat']);
    %'bootstat_DMSO', 'bootstat_CyD50'
    effect_size(i, 1) = calculate_effect_size(bootstat_DMSO, bootstat_CyD50);
    min_value = min(min(bootstat_DMSO), min(bootstat_CyD50));
    max_value = max(max(bootstat_DMSO), max(bootstat_CyD50));
    step = (max_value - min_value) / default_bins;
    figure
    histogram(bootstat_DMSO, min_value:step:max_value);
    hold on;
    histogram(bootstat_CyD50, min_value:step:max_value);
    legend({'DMSO', 'Bleb'});
    xlabel('Proportion', 'fontsize', 14);
    ylabel('Frequency', 'fontsize', 14);
    set(gca, 'fontsize', 14);
    title(['bootstrapped distribution cluster ' num2str(i)], 'fontsize', 16);
    saveas(gcf, fullfile(saved_folder, ['bootstrap_distribution_' num2str(i) '.fig']));
end
save('effect_size.mat', 'effect_size');
