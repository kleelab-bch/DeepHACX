%draw proportion bar

folder = 'CK689_CK666_K_truncated_230_community/Drug_test_normalized_protrusion_samples';
CK689 = load(fullfile(folder, 'CK689_normalized_windows.mat'));
CK666 = load(fullfile(folder, 'CK666_normalized_windows.mat'));
%CC = load(fullfile(folder, 'CC_normalized_windows.mat'));

figure

bar(CK689.total_sample_proportion(:, 1:6));
xticks(1:size(CK689.total_sample_num, 1));
xticklabels(CK689.cell_name);
xtickangle(60);
xlabel('Cell Name');
ylabel('#Samples');
set(gca, 'fontsize', 14);
saveas(gcf, fullfile(folder, 'CK689_Cell_proportion_including_allprotrusions.fig'));
figure
bar(CK666.total_sample_proportion(:, 1:6));
xticks(1:size(CK666.total_sample_num, 1));
xticklabels(CK666.cell_name);
xtickangle(30);
xlabel('Cell Name');
ylabel('#Samples');
set(gca, 'fontsize', 14);
saveas(gcf, fullfile(folder, 'CK666_Cell_proportion_including_allprotrusions.fig'));

% figure
% bar(CC.total_sample_proportion(:, 1:6));
% xticks(1:size(CC.total_sample_num, 1));
% xticklabels(CC.cell_name);
% xtickangle(30);
% xlabel('Cell Name');
% ylabel('#Samples');
% set(gca, 'fontsize', 14);
% saveas(gcf, fullfile(folder, 'CC_Cell_proportion_including_allprotrusions.fig'));