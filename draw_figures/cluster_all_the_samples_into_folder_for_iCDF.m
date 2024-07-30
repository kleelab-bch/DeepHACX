num = length(cl);
Num_cluster = max(cl);
for i = 1 : Num_cluster
    index = find(cl == i);
    folder = [num2str(i), '_cluster_morlet'];
    mkdir(folder);
    for j = 1 : length(index)
        copyfile([num2str(index(j)) '_sample.jpeg'], folder);
    end
end