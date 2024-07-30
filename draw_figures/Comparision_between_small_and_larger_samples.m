%%Read the dataset
dminpool_more_56 = load('../results/larger_56/dminpool_more_56.mat');
dminpool_more_56 = dminpool_more_56.dminpool_more_56 ;
dminpool_less_56 = load('../results/less_56/dminpool_less_56.mat');
dminpool_less_56 = dminpool_less_56.dminpool_less_56 ;
%%Plot the samples without order
figure
subplot(1,2,1);
[ordered_sampleset,length_retraction_whole_protrusion1] = order_samples_by_length(dminpool_less_56.dminpoolv_f_dist);
imagesc(ordered_sampleset);
title('Samples which protrusion length is less than 51');
subplot(1,2,2);
[ordered_sampleset,length_retraction_whole_protrusion1] = order_samples_by_length(dminpool_more_56.dminpoolv_f_dist);
imagesc(ordered_sampleset);
title('Samples which protrusion length is larger than 51');

%%Plot the samples with the order whether they have a full protrusion
%%event.
dminpoolbe_more_56 = dminpool_more_56.dminpoolbe;
dminpoolbe_less_56 = dminpool_less_56.dminpoolbe;
figure
subplot(2,2,1);
order_less_56 = dminpool_less_56.dminpoolv_f_dist(find(dminpoolbe_less_56(:,2) == 1),:);
[ordered_sampleset,length_retraction_whole_protrusion1] = order_samples_by_length(order_less_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (whole protrusion event)');
title('Ordered Samples which protrusion length is less than 51');
subplot(2,2,3);
order_less_56 = dminpool_less_56.dminpoolv_f_dist(find(dminpoolbe_less_56(:,2) == 0),:);
ordered_sampleset = order_samples_by_length(order_less_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (part protrusion event)');
title('Ordered Samples which protrusion length is less than 51');
subplot(2,2,2);
order_more_56 = dminpool_more_56.dminpoolv_f_dist(find(dminpoolbe_more_56(:,2) == 1),:);
[ordered_sampleset,length_retraction_whole_protrusion2] = order_samples_by_length(order_more_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (whole protrusion event)');
title('Ordered Samples which protrusion length is larger than 51');
subplot(2,2,4);
order_more_56 = dminpool_more_56.dminpoolv_f_dist(find(dminpoolbe_more_56(:,2) == 0),:);
ordered_sampleset = order_samples_by_length(order_more_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (part protrusion event)');
title('Ordered Samples which protrusion length is larger than 51');

%%Histogram for the length of protrusion event in which, there is a whole
%%protrusion event.
length_whole_protrusion_even = [length_retraction_whole_protrusion1(:,2); length_retraction_whole_protrusion2(:,2)];
figure,
hist(length_whole_protrusion_even, max(length_whole_protrusion_even));
xlabel('the length of the whole protrusion event');
ylabel('the frequency');
title('The frequency is decreasing with the length increasing');


%%fit the length of the whole protrusion with GMM.

max_Comp = 50;
obj = cell(max_Comp-1, 1);
BIC = zeros(max_Comp-1,1);
AIC = zeros(max_Comp-1,1);
i = 1;
for K = 2:max_Comp
    obj{K-1,1} = gmdistribution.fit(length_whole_protrusion_even, K, 'Options', statset('MaxIter', 1500));
    BIC(K-1, 1) = obj{K-1}.BIC;
    AIC(K-1, 1) = obj{K-1}.AIC;
end
%From the figure, 5 is the best.
figure,
plot(2:max_Comp, BIC, '*');
hold on;
plot(2:max_Comp, AIC, '-');
title('BIC VS AIC');
xlabel('The number of Gaussian Distribution');
ylabel('Value');

%%Draw the fitted distribution and get the boundary.
%Draw the fitted distrubtion
K = 5;
obj = gmdistribution.fit(length_whole_protrusion_even, K, 'Options', statset('MaxIter', 1500));
x_values = 10:1:160;
y_values = pdf(obj,x_values');
c_values = cdf(obj, x_values');
figure,
min_len = min(length_whole_protrusion_even);
max_len = max(length_whole_protrusion_even);
h = hist(length_whole_protrusion_even, max_len - min_len + 1);
h = h / sum(h);
bar(min_len:1:max_len, h, 'DisplayName', 'Normalized histogram of the length of whole protrusion event');
xlabel('the length of the whole protrusion event');
ylabel('the frequency');
title('PDF, CDF to fit the histogram of the length of the whole protrusion event');
%yyaxis left
hold on
[hAx, hLine1, hLine2] =plotyy(x_values, y_values, x_values, c_values);
hLine1.LineStyle = '-';
hLine2.LineStyle = '--';
ylabel(hAx(1), 'PDF for GMM fit');
ylabel(hAx(2), 'CDF for GMM fit');
legend('Histogram', 'PDF', 'CDF');
legend('show');

%Get the boundary result.
%Different Ways:
%Opt1: CDF equally.
%Since there is no easy way to calculate the icdf for GMM and We just want
%to get the discrete number. We can use the c_values to search and find the
%numbers.
dminpoolv = [dminpool_less_56.dminpoolv_f_dist(find(dminpoolbe_less_56(:,2) == 1),:);
dminpool_more_56.dminpoolv_f_dist(find(dminpoolbe_more_56(:,2) == 1),:)];
%cell marker
dminpoolc_lesss_56 = {dminpool_less_56.dminpoolc{1,find(dminpoolbe_less_56(:,2) == 1)}};
dminpoolc_more_56 = {dminpool_more_56.dminpoolc{1, find(dminpoolbe_more_56(:,2) == 1)}};
dminpoolc = [dminpoolc_lesss_56 dminpoolc_more_56];
%intensity
dminpool = [dminpool_less_56.dminpool(find(dminpoolbe_less_56(:,2) == 1),:);
dminpool_more_56.dminpool(find(dminpoolbe_more_56(:,2) == 1),:)];

%window
dminpoolw = [dminpool_less_56.dminpoolw(find(dminpoolbe_less_56(:,2) == 1)), dminpool_more_56.dminpoolw(find(dminpoolbe_more_56(:,2) == 1))];

%time
dminpoolt = [dminpool_less_56.dminpoolt(find(dminpoolbe_less_56(:,2) == 1)), dminpool_more_56.dminpoolt(find(dminpoolbe_more_56(:,2) == 1))];
save('whole_protrusion_event.mat', 'dminpoolv', 'dminpool', 'dminpoolc', 'dminpoolw', 'dminpoolt');
save('../whole_protursion_event_different_group/whole_protrusion_event.mat', 'dminpoolv', 'dminpool', 'dminpoolc', 'dminpoolw', 'dminpoolt');
%%Draw the proporation of each protein.
%Get the sample set for different protein.
len = length(dminpoolc);
protein_labels = zeros(1, len);
protein_names = {'Actin', 'Arp23', 'Cofilin1', 'VASP', 'Halo', 'mDia1', 'mDia2'};
for i = 1 : len
    %find the protein
    for j = 1 : length(protein_names)
        label = strfind(dminpoolc{1,i}, protein_names{j});
        if label == 1
            protein_labels(1,i) = j;
            break;
        end
    end     
end


protein_bar_value = zeros(length(protein_names),1);
for i = 1 : length(protein_names)
    protein_bar_value(i,1) = length(find(protein_labels == i));
end
figure
bar(protein_bar_value);
set(gca, 'XTick', 1:length(protein_names), 'XTickLabel', protein_names);
title('The proporation of each protein in the dataset with the whole protrusion event');

%%
%Draw the protein for each group using iCDF
B_interval = 10;
boundary = zeros(B_interval-1,1);
for i = 1 : B_interval-1
    diff = (c_values - 1.0/B_interval * i);
    [~, index] = min(abs(diff));
    %just exclude the number which is larger than integer number.
    if diff(index) > 0
        index = index - 1;
    end
    boundary(i,1) = x_values(1,index);
end
[cells_time_hetergeneity_cdf_equally, group_label] = generate_time_hetergenerty_data(dminpoolv, boundary);
[dminpoolv, dminpool, dminpoolc, dminpoolw, dminpoolt] = generate_corresponding_order(dminpoolv, dminpool, dminpoolc, dminpoolw, dminpoolt, group_label, B_interval);
% dminpoolv = dminpoolv(group_label,:);
% dminpool = dminpool(group_label,:);
% dminpoolc = {dminpoolc{group_label}};
% dminpoolw = dminpoolw(group_label);
% dminpoolt = dminpoolt(group_label);
save('order_CDF_whole_protrusion_event.mat', 'dminpoolv', 'dminpool', 'dminpoolc', 'dminpoolw', 'dminpoolt');
save('../whole_protursion_event_different_group/order_CDF_whole_protrusion_event.mat', 'dminpoolv', 'dminpool', 'dminpoolc', 'dminpoolw', 'dminpoolt');


figure
draw_time_hetergeneity(cells_time_hetergeneity_cdf_equally, boundary, -0.5, 3);
title('The time hetergeneity based on the equal interval from inverse CDF');
hold off;
save('cell_time_hetergeneity_cdf_equally.mat', 'cells_time_hetergeneity_cdf_equally');
save('cell_time_hetergeneity_cdf_group_label.mat', 'group_label');

for i = 1 : B_interval
    figure
    [ordered_sampleset,length_retraction_whole_protrusion1] = order_samples_by_length(cells_time_hetergeneity_cdf_equally{i,1});
    imagesc(ordered_sampleset);
end

%%Draw the protein for each group
group = {};
for i = 1 : B_interval
    index = find(group_label == i);
    dminpoolv_group = dminpoolv(index,:);
    dminpool_group = dminpool(index,:);
    protein_group = protein_labels(index);
    group{1, i} = {dminpoolv_group, dminpool_group, protein_group};
    draw_time_hetergeneity_protein(dminpoolv_group, dminpool_group, protein_group, protein_names);
end
group{1,11} = protein_names;
save('icdf_equally_each_group.mat', 'group');

%%Opt2: GMM;
idx = cluster(obj, length_whole_protrusion_even);
clusters = cell(K,1);
interval = zeros(K, 2);
for i = 1 : K
    clusters{i,1} = length_whole_protrusion_even(idx == i);
    interval(i,1) = min(clusters{i,1});
    interval(i,2) = max(clusters{i,1});
end
%get the boundary for GMM
boundary_GMM = sort(interval(:,2));
boundary_GMM = boundary_GMM(1:4);
[cells_time_hetergeneity_GMM, group_label] = generate_time_hetergenerty_data(dminpoolv, boundary_GMM);
save('cell_time_hetergeneity_GMM.mat', 'cells_time_hetergeneity_GMM');
save('cell_time_hetergeneity_GMM_group_label.mat','group_label');
for i = 1 : K
    figure
    [ordered_sampleset,length_retraction_whole_protrusion1] = order_samples_by_length(cells_time_hetergeneity_GMM{i,1});
    imagesc(ordered_sampleset);
end

figure
draw_time_hetergeneity(cells_time_hetergeneity_GMM, boundary_GMM, -0.5, 3);
title('The time hetergeneity based on the GMM');
hold off;


%%Draw the protein for each group
group = {};
for i = 1 : K
    index = find(group_label == i);
    dminpoolv_group = dminpoolv(index,:);
    dminpool_group = dminpool(index,:);
    protein_group = protein_labels(index);
    group{1, i} = {dminpoolv_group, dminpool_group, protein_group};
    draw_time_hetergeneity_protein(dminpoolv_group, dminpool_group, protein_group, protein_names);
end
group{1,K+1} = protein_names;
save('GMM_each_group.mat', 'group');
%Opt3: H-Clustering




%%More details
figure
subplot(4,2,1);
order_less_56 = dminpool_less_56.dminpoolv_f_dist(find(dminpoolbe_less_56(:,2) == 1 & dminpoolbe_less_56(:,1) == 1),:);
[ordered_sampleset,length_retraction_protrusion1] = order_samples_by_length(order_less_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (whole protrusion and retraction event)');
title('Ordered Samples which protrusion length is less than 51');
subplot(4,2,3);
order_less_56 = dminpool_less_56.dminpoolv_f_dist(find(dminpoolbe_less_56(:,2) == 1 & dminpoolbe_less_56(:,1) == 0),:);
ordered_sampleset = order_samples_by_length(order_less_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (whole protrusion and part retraction event)');
title('Ordered Samples which protrusion length is less than 51');
subplot(4,2,5);
order_less_56 = dminpool_less_56.dminpoolv_f_dist(find(dminpoolbe_less_56(:,2) == 0 & dminpoolbe_less_56(:,1) == 1),:);
ordered_sampleset = order_samples_by_length(order_less_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (whole retraction and part protrusion event)');
title('Ordered Samples which protrusion length is less than 51');
subplot(4,2,7);
order_less_56 = dminpool_less_56.dminpoolv_f_dist(find(dminpoolbe_less_56(:,2) == 0 & dminpoolbe_less_56(:,1) == 0),:);
ordered_sampleset = order_samples_by_length(order_less_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (part retraction and part protrusion event)');
title('Ordered Samples which protrusion length is less than 51');
subplot(4,2,2);
order_more_56 = dminpool_more_56.dminpoolv_f_dist(find(dminpoolbe_more_56(:,2) == 1 & dminpoolbe_more_56(:,1) == 1),:);
[ordered_sampleset,length_retraction_protrusion2] = order_samples_by_length(order_more_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (whole retraction and protrusion event)');
title('Ordered Samples which protrusion length is larger than 51');
subplot(4,2,4);
order_more_56 = dminpool_more_56.dminpoolv_f_dist(find(dminpoolbe_more_56(:,2) == 1 & dminpoolbe_more_56(:,1) == 0),:);
ordered_sampleset = order_samples_by_length(order_more_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (part retraction and whole protrusion event)');
title('Ordered Samples which protrusion length is larger than 51');
subplot(4,2,6);
order_more_56 = dminpool_more_56.dminpoolv_f_dist(find(dminpoolbe_more_56(:,2) == 0 & dminpoolbe_more_56(:,1) == 0),:);
ordered_sampleset = order_samples_by_length(order_more_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (part retraction and protrusion event)');
title('Ordered Samples which protrusion length is larger than 51');
subplot(4,2,8);
order_more_56 = dminpool_more_56.dminpoolv_f_dist(find(dminpoolbe_more_56(:,2) == 0 & dminpoolbe_more_56(:,1) == 1),:);
ordered_sampleset = order_samples_by_length(order_more_56);
imagesc(ordered_sampleset);
xlabel('image frame');
ylabel('#sample (whole retraction and part protrusion event)');
title('Ordered Samples which protrusion length is larger than 51');

%%Draw the relationship between the length of retraction event and the length of
%%protrusion event.
%There is no clear correlation between the length of retraction event and
%that of protrusion event.
length_retraction_protrusion = [length_retraction_protrusion1; length_retraction_protrusion2];
figure,
plot(length_retraction_protrusion(:,1), length_retraction_protrusion(:,2), '*');
xlabel('the length of retraction event');
ylabel('the length of protrusion event');
title('relationship between the length of retraction event and that of protrusion event');



%%Plot the mean and confidence interval.
figure
subplot(1,2,1);
draw_confidence_interval(dminpool_less_56.dminpoolv_f_dist, 'velocity', 'global result shorter sample');
subplot(1,2,2);
draw_confidence_interval(dminpool_more_56.dminpoolv_f_dist, 'velocity', 'global result larger sample');

%%The frame length
figure
subplot(2,1,1)
time_cluster = dminpool_less_56.dminpoolv_f_dist(:, 201:end);
time_cluster_frequency = sum(~isnan(time_cluster), 2);
hist(time_cluster_frequency, max(time_cluster_frequency));
xlabel('the length of time');
ylabel('frequency');
xlim([1, 200]);
event = 'short sample';
title(event);

subplot(2,1,2)
time_cluster = dminpool_more_56.dminpoolv_f_dist(:, 201:end);
time_cluster_frequency = sum(~isnan(time_cluster), 2);
hist(time_cluster_frequency, max(time_cluster_frequency));
xlabel('the length of time');
ylabel('frequency');
xlim([1, 200]);
event = 'long sample';
title(event);