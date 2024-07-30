
pathname = './Actin_mDia1';
files = dir(fullfile(pathname, '*corr_mDia_actin.fig'));
num_files = length(files);

%Change the limit and label
pathname2 = fullfile(pathname, 'mDia_actin');
mkdir(pathname2);
i = 6;
for i = 1 : num_files
    filename = files(i).name;
    fig = openfig(fullfile(pathname, filename));

    xlim([151, 261]);
    ylim([151, 261]);
    set(gca, 'XTick', [151:10:261]);
    set(gca, 'YTick', [151:10:261]);
    set(gca, 'XTickLabel', {'-250'; '-200'; '-150';'-100'; '-50'; '0'; '50'; '100'; '150'; '200'; '250'; '300'});
    set(gca, 'YTickLabel', {'-250'; '-200'; '-150';'-100'; '-50'; '0'; '50'; '100'; '150'; '200'; '250'; '300'});
    axis square

    xlim([181, 251]);
    %ylim([181, 251]);
    set(gca, 'XTick', [181:10:251]);
    %set(gca, 'YTick', [181:10:251]);
    set(gca, 'XTickLabel', {'-100'; '-50'; '0'; '50'; '100'; '150'; '200'; '250'});
    %set(gca, 'YTickLabel', {'-100'; '-50'; '0'; '50'; '100'; '150'; '200'; '250'});
    caxis([-3,3]) % change caxis
    axis square
    
    saveas(gcf, fullfile(pathname2, filename));
    close all;
end

    xlim([1, 56]);
    set(gca, 'XTick', [1:10:56]);
    set(gca, 'XTickLabel', {'-25'; '25'; '75'; '125'; '175'; '225'});
    xlabel('Time (s)');
    
    xlim([-100, 250]);
    
    figure
    xlim([-100, 250]);
    ylim([-1.5,3.5]);
    line([0 0],[-1.5, 3.5], 'Color', [0, 0, 0]);
    
    ylim([-1.5, 3]);
    xlim([-100, 250]);
     
     
    ylim([200, 600]);
    xlim([-100, 250]);
    
    xlim([1, 3]);
    set(gca, 'XTick', [1:1:3]);
    set(gca, 'XTickLabel', {'Actin'; 'Arp2/3'; 'VASP'});
    
    ylim([0, 1]);
    set(gca, 'YTick', [0:0.1:1]);
    set(gca, 'YTickLabel', {'0'; '10'; '20'; '30'; '40'; '50'; '60'; '70'; '80'; '90'; '100'});
    
    hold on;
    plot([0, 0], [-1.5, 3.5], ':k')
    
    hold on;
    plot([0, 0], [200, 650], ':k');
figure
subplot(2,1,1);
plot(nanmean(norm_eb1_d_for_each));
subplot(2,1,2);
plot(nanmean(norm_tacc3_d_for_each));
% %put all figure together of the same protein.
% protein = {'Actin', 'Arp23', 'Cofilin1', 'Halo', 'mDia1', 'mDia2', 'VASP'};
% 
% i = 1;
% for i = 1 : length(protein)
%     files = dir(fullfile(pathname2, [protein{i}, '*corr_vel_int.fig']));
%     figure
%     num_files = length(files);
%     j = 1;
%     for j = 1 : num_files
%         filename = files(j).name;
%         Sub = subplot(1, num_files, j);
%         hfig = openfig(fullfile(pathname2, filename), 'reuse');
%         ax1 = gca; %get handle to axes of figure
%         fig1 = get(ax1, 'children');
%         copyobj(fig1, Sub); %copy children to new parent axes .
%         
%         axis square
%     end
%     saveas(gcf, fullfile(pathname2, [protein{i} '.fig']));
% end