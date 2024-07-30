load('Data.mat');
%Histogram of Vel.
Interval_Vel = Vel(:, 196:251);
Index = ~isnan(Interval_Vel);
Interval_vel_nonNaN = Interval_Vel(Index);
%% Histogram of velocity
min_vel = min(Interval_vel_nonNaN);
max_vel = max(Interval_vel_nonNaN);
edges = [min_vel : 0.1 : max_vel];
figure
subplot(1,2,1);
histogram(Interval_vel_nonNaN, edges);
xlabel('Velocity', 'fontsize', 16);
ylabel('Frequency', 'fontsize', 16);
title('Velocity Distribution', 'fontsize', 16);
set(gca, 'fontsize', 16);
subplot(1,2,2);
histogram(Interval_vel_nonNaN, edges);
ylim([0, 100]);
xlabel('Velocity', 'fontsize', 16);
ylabel('Frequency', 'fontsize', 16);
set(gca, 'fontsize', 16);
title('Velocity Distribution with a cut', 'fontsize', 16);

%% Sigmoid Function
% figure
% x = [-10:0.01:20];
% y = 2 * (sigmf(x,[0.3 0]) - 0.5);
% plot(x,y, 'LineWidth', 2);
% hold on;
% line([-10,20],[0,0],'Color','red','LineStyle','--', 'LineWidth', 2);
% hold on;
% line([0,0],[-1,1],'Color','red','LineStyle','--', 'LineWidth', 2);
% xlabel('Velocity Range', 'fontsize', 16);
% ylabel('Mapping Range', 'fontsize', 16);
% title('Normalization', 'fontsize', 16);
% set(gca, 'fontsize', 16);
% saveas(gcf, 'Mapping_function Visualization.fig');

% Mapping Velocity function.
% [row, col] = size(Vel);
% Mapping_Vel = NaN(size(Vel));
% for i = 1 : row
%     for j = 1 : col
%         if ~isnan(Vel(i, j))
%             Mapping_Vel(i, j) = 2 * (sigmf(Vel(i, j),[0.3 0]) - 0.5);
%         end
%     end
% end
% Mapping_Vel = Mapping_Vel(:, 196:251);
% save('Mapping_Vel.mat', 'Mapping_Vel', 'label');

%% Linear Normalization
[row, col] = size(Vel);
Mapping_Vel = NaN(size(Vel));
for i = 1 : row
    for j = 1 : col
        if ~isnan(Vel(i, j))
            Mapping_Vel(i, j) = 2 * (Vel(i, j) - min_vel) / (max_vel - min_vel) - 1;
        end
    end
end
Mapping_Vel = Mapping_Vel(:, 196:251);
save('LinearMapping_Vel.mat', 'Mapping_Vel', 'label');
%% Visualization
figure
subplot(1,2,1);
imagesc(Vel, [-10, 20]);
xlabel('Frame', 'fontsize', 16);
ylabel('Sample Index', 'fontsize', 16);
title('Raw Velocity', 'fontsize', 16);
set(gca, 'fontsize', 16);
colorbar;
subplot(1,2,2);
imagesc(Mapping_Vel, [-1, 1]);
xlabel('Frame', 'fontsize', 16);
ylabel('Sample Index', 'fontsize', 16);
title('Scaled Normalization', 'fontsize', 16);
set(gca, 'fontsize', 16);
colorbar;
saveas(gcf, 'Raw_velocity VS Linear_normalization.fig');
