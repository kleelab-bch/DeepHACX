function [vel_f_dist, acc_f_dist] = get_vel_f_denoise_distance(distance, velocity)
%%
%Here we need the first value of velocity.
[row, col] = size(distance);

vel_f_dist = NaN(row, col);
acc_f_dist = NaN(row, col);
%Tranfer distance to velocity.
for i = 1: row
    vel_f_dist(i,1) = velocity(i,1);
    vel_f_dist(i,2:end) = diff(distance(i,:));
    acc_f_dist(i,1:end-1) = diff(vel_f_dist(i,1:end));
end


