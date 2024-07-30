
function alignmentdata(pathname, save_folder, prefix_video, pathname2)
%pathname: the folder saving the data from windowing package.
%save_folder: the folder to save the results from this function.
%pathnames2: the intermediate paths used in pathname: the default value: 'WindowingPackage\protrusion_samples'

%For example:
% pathname = '\\research.wpi.edu\leelab\Kwonmoo\bleb';
% pathname2 = 'WindowingPackage\protrusion_samples';
% save_folder = '\\research.wpi.edu\leelab\Chauncey\Projects\paper4_Bleb\bleb\results\alignmentdata';
% prefix_video = '*_Bleb_*' #only analyze the video which names contain
% "Bleb"

switch nargin
    case 1
        save_folder = '..\results\alignmentdata';
        pathname2 = 'WindowingPackage\protrusion_samples';
        prefix_video = '*';
    case 2
        pathname2 = 'WindowingPackage\protrusion_samples';
        prefix_video = '*';
    case 3
        pathname2 = 'WindowingPackage\protrusion_samples';
    case 4
        print("All four intpus are loaded");
    otherwise
        print("The folder saving the data from windowing package is needed or too many inputs");
        exit(0);    
end

    
%Create a folder.
mkdir(save_folder);

%Get the inputVideo list.
inputFileList = dir(fullfile(pathname, prefix_video));
i = 1;
sum_boundary = {};
num_sample = zeros(1, length(inputFileList));
    for i = 1 : length(inputFileList)
        filename = inputFileList(i,1).name
        %for each sample.
        if exist(fullfile(fullfile(fullfile(pathname, filename), pathname2), 'protrusion_samples.mat'), 'file') == 2
            protSamples = load(fullfile(fullfile(fullfile(pathname, filename), pathname2), 'protrusion_samples.mat'));
            vel = protSamples.protSamples.avgNormal;
            %vel = [NaN(size(vel, 1), 1), vel];
            %remove the outliers:
            [vel, boundary] = trim_outliers(vel, save_folder, filename);
            sum_boundary{1,i} = boundary;
            %here, we just use the velocity. and input velocity into activity just
            %for convenience.
            [row, col] = size(vel);
            num_sample(1, i) = row;
            iteration = floor(col/200);
            for j = 1 : iteration
                left = (j - 1) * 200 + 1;
                right = j * 200;
                alignments = alignProtrusionEvents_Chauncey(vel(:, left:right), vel(:, left:right), filename);
                save(fullfile(save_folder,['align_' num2str(j) '_' filename]), 'alignments');
                clear alignments;
            end
        end
    end
save (fullfile(save_folder, 'velocity_interval.mat'), 'sum_boundary');

%%
%get the protrusion samples for each cells.
cell_name = {};
for i = 1 : length(inputFileList)
    cell_name{1, i} = inputFileList(i,1).name;
end

filename = 'align_1_*';
filelists = dir(fullfile(save_folder, filename));
num_sample = zeros(1, length(filelists));
cell_name = {};
for i = 1 : length(filelists)
    protSamples = load(fullfile(save_folder, filelists(i, 1).name));
    cell_name{1, i} = filelists(i,1).name;
    num_sample(1, i) = size(protSamples.alignments.protrusionOnset.velocity, 1);
end
figure
bar(1:length(num_sample), num_sample);
xlabel('Cell Name', 'FontSize', 16);
ylabel('Protrusion Number', 'FontSize', 16);
title('Protrusion Population', 'FontSize', 16);
set(gca,'XTick',1:length(cell_name));
set(gca,'XTickLabel',cell_name);
set(gca,'XTickLabelRotation',20);
set(gca,'fontsize', 16);
axis square
saveas(gcf, fullfile(save_folder, 'Protrusion_population.fig'));
end