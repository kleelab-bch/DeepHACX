K_cluster = 6;
pValue  = NaN(K_cluster, 2);
CI_aligned = NaN(K_cluster, 2, 2);
mean_aligned = NaN(K_cluster, 2);
for i = 1 : K_cluster
    [bootstat_DMSO,bootsam_DMSO]=bootstrp(10000,@boot_acc_total_sample_none, i, 1:14);
    [bootstat_CyD50,bootsam_CyD50]=bootstrp(10000,@boot_acc_total_sample_Bleb, i, 1:13);

    pValue_DMSO_CyD50 = sum(bootstat_CyD50-bootstat_DMSO < 0)/length(bootstat_CyD50)
    pValue(i, 1) = 1 - pValue_DMSO_CyD50;
    pValue(i, 2) = pValue_DMSO_CyD50;
    save(['bootstate_value_' num2str(i) '.mat'], 'bootstat_DMSO', 'bootstat_CyD50');
    CI_aligned(i, 1, :) = bootci(10000, @boot_acc_total_sample_none, i, 1:14);
    CI_aligned(i, 2, :) = bootci(10000,@boot_acc_total_sample_Bleb, i, 1:13);
    mean_aligned(i, 1) = mean(bootstat_DMSO);
    mean_aligned(i, 2) = mean(bootstat_CyD50);
end
save('mean_CI_pvalue.mat', 'mean_aligned', 'CI_aligned', 'pValue');

load('mean_CI_pvalue.mat');
CI_aligned(:, :, 1) = mean_aligned - squeeze(CI_aligned(:, :, 1));
CI_aligned(:, :, 2) = squeeze(CI_aligned(:, :, 2)) - mean_aligned;

%Bar plot
%Bar plot
figure
h = barwitherr(CI_aligned(:, 1:2, :), mean_aligned(:, 1:2));
legend({'None','Bleb'});
ylabel('Cluster Proportion');
xlim([0.5, 6.5]);
set(gca,'XTickLabel',{'1', '2', '3' , '4', '5', '6', '7'});
set(gca, 'fontsize', 14, 'fontname', 'Arial');
axis square
saveas(gcf, 'BarPlot.fig');
