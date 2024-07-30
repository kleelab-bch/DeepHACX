%draw density peaks for the entire protrusion event/ long samples dataset/ short samples dataset/ individual group dataset.
function draw_figure_for_individual_groups()

name_list = {'GMM_group1', 'GMM_group2','GMM_group3','GMM_group4','GMM_group5'};
name_list2 = {'iCDF_1','iCDF_2','iCDF_3','iCDF_4','iCDF_5','iCDF_6','iCDF_7','iCDF_8','iCDF_9','iCDF_10'};


% filesAndfolder = dir(pathname);
% filesInDir = filesAndfolder(~([filesAndfolder.isdir]));
% filesNames = filesInDir.name;
%find the different file and do density peaks.

i = 4;
for i = 1 : length(name_list)
    pathname = fullfile('../whole_protursion_event_different_group', name_list{1,i});
    samples = load(fullfile('../whole_protursion_event_different_group', ['time_hetergeneity_GMM_group', num2str(i), '.mat']));
    dminpoolv = samples.dminpoolv;
    draw_figures_for_each_group(pathname, dminpoolv);
end

end

