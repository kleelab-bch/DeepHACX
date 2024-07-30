function [ordered_sampleset, length_retraction_protrusion] = order_samples_by_length(sampleset, opt)
%This function, the sampleset will be ordered by the length of protruset and retraction set.
%%The input is the dataset.

%%The output is the ordered dataset.
if (nargin<2)
    opt = 1;
end

%
% sampleset = order_less_56;
[row, col] = size(sampleset);
length_retraction_protrusion = zeros(row, 2);
length_retraction_protrusion(:,1) = sum(~isnan(sampleset(:, 1:201)), 2);
length_retraction_protrusion(:,2) = sum(~isnan(sampleset(:, 201:end)), 2);
%
%Opt1 By the protrusion length
if opt == 1
[~, index] = sort(length_retraction_protrusion(:,2));
ordered_sampleset = sampleset(index,:);
else
%opt2: Consider the length of retraction and protrusion event.
% [~, index] = sort(length_retraction_protrusion(:,1) + length_retraction_protrusion(:,2));
% ordered_sampleset = sampleset(index,:);
figure
plot(length_retraction_protrusion(:,1), length_retraction_protrusion(:,2),'*');
xlabel('the length of whole retraction event');
ylabel('the length of whole protrusion event');
title('The relationship between the length of whole retraction event and whole protrusion event');

dist = pdist(length_retraction_protrusion, 'cityblock');
tree = linkage(dist, 'average');
%leafOrder = optimalleaforder(tree,dist);
figure
dendrogram(tree);
%dendrogram(tree, 'Reorder', leafOrder);

K = 4;
T = cluster(tree, 'maxclust', K);
end
end