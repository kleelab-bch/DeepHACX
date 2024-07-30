function [dminpoolv, dminpool, dminpoolc, dminpoolw, dminpoolt] = generate_corresponding_order(velocity, intensity, cell_label, windowing, time_frame, group_label, B_interval)

%loop each iCDF
dminpoolv = [];
dminpool = [];
dminpoolc = {};
dminpoolw = [];
dminpoolt = [];
for i = 1 : B_interval
    index = find(group_label == i);
    dminpoolv = [dminpoolv; velocity(index,:)];
    dminpool = [dminpool; intensity(index,:)];
    dminpoolc = [dminpoolc, cell_label{index}];
    dminpoolw = [dminpoolw, windowing(index)];
    dminpoolt = [dminpoolt, time_frame(index)];
end
end