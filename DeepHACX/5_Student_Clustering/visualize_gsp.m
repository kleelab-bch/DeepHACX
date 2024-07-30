function h = visualize_gsp(out1, out2, out3, ms, save_name)
%Here we visualize the different figures based on the unified colorbar
c = [out1.dd; out2.dd; out3.dd];
%Graphs scattered poits
colormap('jet');
map = colormap;
ind = fix((c-min(c))/(max(c)-min(c))*(size(map,1)-1))+1;
h = [];
%much more efficient than matlab's scatter plot
%% out1
figure
colormap('jet');
map = colormap;
ind1 = ind(1:length(out1.dd),1);
for k=1:size(map,1) 
    if any(ind1==k)
        h(end+1) = line('Xdata',out1.x(ind1==k),'Ydata',out1.y(ind1==k), ...
            'LineStyle','none','Color',map(k,:), ...
            'Marker','.','MarkerSize',ms);
    end
end
axis square;
title(save_name{1,1});
set(gca, 'fontsize', 16);
xlim([-150, 150]);
ylim([-100, 100]);
colorbar   
set(gca,'fontsize', 16);
saveas(gcf, [save_name{1,1} '_density.fig']);
%% out2
figure
colormap('jet');
map = colormap;
ind2 = ind(1+length(out1.dd):length(out1.dd) + length(out2.dd),1);
for k=1:size(map,1) 
    if any(ind2==k)
        h(end+1) = line('Xdata',out2.x(ind2==k),'Ydata',out2.y(ind2==k), ...
            'LineStyle','none','Color',map(k,:), ...
            'Marker','.','MarkerSize',ms);
    end
end
axis square;
title(save_name{1,2});
set(gca, 'fontsize', 16);
xlim([-150, 150]);
ylim([-100, 100]);
colorbar   
set(gca,'fontsize', 16);
saveas(gcf, [save_name{1,2} '_density.fig']);
%% out3
figure
colormap('jet');
map = colormap;
ind3 = ind(1+ length(out1.dd) + length(out2.dd): length(out1.dd) + length(out2.dd) + length(out3.dd),1);
for k=1:size(map,1) 
    if any(ind3==k)
        h(end+1) = line('Xdata',out3.x(ind3==k),'Ydata',out3.y(ind3==k), ...
            'LineStyle','none','Color',map(k,:), ...
            'Marker','.','MarkerSize',ms);
    end
end
axis square;
title(save_name{1,3});
set(gca, 'fontsize', 16);
xlim([-150, 150]);
ylim([-100, 100]);
colorbar 
set(gca,'fontsize', 16);
saveas(gcf, [save_name{1,3} '_density.fig']);
end