function alignment_pooled = poolNormalizedData(pathname)
%This function is a little different from the previous one.
%In this function, we directly get the filename list from the folder.
%[filename, pathname] = uigetfile({'*.*'}, 'Select First Image');
   
if  ~ischar(pathname)
     return;
end
%cd (pathname);
inputFileList = dir(fullfile(pathname, 'align_*.mat'));
%inputFileList = getFileStackNames([pathname filesep filename]);
nFiles = length(inputFileList);
%[m nFiles]=size(inputFileList);

layerProfileVmax=[];
dminpool=[];
dmaxpool=[];
vmaxpool=[];
vmaxdminpool=[];
pmidpool=[];
dminpoolv=[];
dmaxpoolv=[];
vmaxpoolv=[];
vmaxdminpoolv=[];
pmidpoolv=[];
layerpool=[];
vpool=[];

dminpool_window = [];
dminpool_time = [];
%Add the new information
dminpool_begining_ending = [];
dminpool_window_cycle = [];

dmaxpool_window = [];
dmaxpool_time = [];
dmaxpool_begining_ending = [];
dmaxpool_window_cycle = [];

vmaxpoolv_window = [];
vmaxpoolv_time = [];
vmaxpoolv_begining_ending = [];
vmaxpoolv_window_cycle = [];

vmaxdminpoolv_window = [];
vmaxdminpoolv_time = [];
vmaxdminpoolv_begining_ending = [];
vmaxdminpoolv_window_cycle = [];

vmaxpoolv_cell_marker = [];
dmaxpool_cell_marker = [];
dminpool_cell_marker = [];

actROpool=[];actPOpool=[];
vROpool=[];vPOpool=[];
maxvpool=[];
timepool=[];
sumCorrRO=0;
sumCorrPO=0;
sumCorrPMV=0;
corrPool=[];
for j=1:nFiles
    inputFileList(j).name
    %load(inputFileList{j});
    load(fullfile(inputFileList(j).folder, inputFileList(j).name));
    alignment=alignments;
    if size(alignment.protrusionOnset.activity, 1) > 1
        dminpool=[dminpool; padNaN(alignment.protrusionOnset.activity)];
        dminpoolv=[dminpoolv; padNaN(alignment.protrusionOnset.velocity)];
        dminpool_window = [dminpool_window, alignment.protrusionOnset.window];
        dminpool_time = [dminpool_time, alignment.protrusionOnset.time];
        row = length(alignment.protrusionOnset.time);S
        marker = cellstr(alignment.metaData);
        dminpool_cell_marker = [dminpool_cell_marker,repmat(marker, 1, row)];
        dminpool_begining_ending = [dminpool_begining_ending; [alignment.protrusionOnset.begining; alignment.protrusionOnset.ending]'];
        dminpool_window_cycle = [dminpool_window_cycle; alignment.protrusionOnset.window_cycle];
    end
    
    if size(alignment.retractionOnset.activity, 1) > 1
        dmaxpool=[dmaxpool; padNaN(alignment.retractionOnset.activity)];
        dmaxpoolv=[dmaxpoolv; padNaN(alignment.retractionOnset.velocity)];
        dmaxpool_window = [dmaxpool_window, alignment.retractionOnset.window];
        dmaxpool_time = [dmaxpool_time, alignment.retractionOnset.time];
        row = length(alignment.retractionOnset.time);
        marker = cellstr(alignment.metaData);
        dmaxpool_cell_marker = [dmaxpool_cell_marker,repmat(marker, 1, row)];
        dmaxpool_begining_ending = [dmaxpool_begining_ending; [alignment.retractionOnset.begining; alignment.retractionOnset.ending]'];
        dmaxpool_window_cycle = [dmaxpool_window_cycle; alignment.retractionOnset.window_cycle];
    end
    
    if size(alignment.protrusionMaxVelocity.activity, 1) > 1
        vmaxpool=[vmaxpool; padNaN(alignment.protrusionMaxVelocity.activity)];
        vmaxpoolv=[vmaxpoolv; padNaN(alignment.protrusionMaxVelocity.velocity)];
        vmaxpoolv_window = [vmaxpoolv_window, alignment.protrusionMaxVelocity.window];
        vmaxpoolv_time = [vmaxpoolv_time, alignment.protrusionMaxVelocity.time];
        row = length(alignment.protrusionMaxVelocity.time);
        marker = cellstr(alignment.metaData);
        vmaxpoolv_cell_marker = [vmaxpoolv_cell_marker,repmat(marker, 1, row)];
        vmaxpoolv_begining_ending = [vmaxpoolv_begining_ending; [alignment.protrusionMaxVelocity.begining; alignment.protrusionMaxVelocity.end]'];
        vmaxpoolv_window_cycle = [vmaxpoolv_window_cycle; alignment.protrusionMaxVelocity.window_cycle];
    end
    
    vmaxdminpool=[vmaxdminpool; padNaN(alignment.protrusionMaxVelocityFromProtrusionOnsetData.activity)];
    vmaxdminpoolv=[vmaxdminpoolv; padNaN(alignment.protrusionMaxVelocityFromProtrusionOnsetData.velocity)];
    % vmaxdminpoolv_window = [vmaxdminpoolv_window, alignment.protrusionMaxVelocityFromProtrusionOnsetData.window];
    % vmaxdminpoolv_time = [vmaxdminpoolv_time, alignment.protrusionMaxVelocityFromProtrusionOnsetData.time];
    
    pmidpool=[pmidpool; alignment.normlaizedPOnsetPMaxVelocity.activity];
    pmidpoolv=[pmidpoolv; alignment.normlaizedPOnsetPMaxVelocity.velocity];
end

alignment_pooled.dminpool = dminpool;
alignment_pooled.dminpoolv = dminpoolv;
alignment_pooled.dminpool_window = dminpool_window;
alignment_pooled.dminpool_time = dminpool_time;
alignment_pooled.dminpool_begining_ending = dminpool_begining_ending;
alignment_pooled.dminpool_window_cycle = dminpool_window_cycle;

alignment_pooled.dmaxpool = dmaxpool;
alignment_pooled.dmaxpoolv = dmaxpoolv;
alignment_pooled.dmaxpool_window = dmaxpool_window;
alignment_pooled.dmaxpool_time = dmaxpool_time;
alignment_pooled.dmaxpool_begining_ending = dmaxpool_begining_ending;
alignment_pooled.dmaxpool_window_cycle = dmaxpool_window_cycle;

alignment_pooled.vmaxpool = vmaxpool;
alignment_pooled.vmaxpoolv = vmaxpoolv;
alignment_pooled.vmaxpool_window = vmaxpoolv_window;
alignment_pooled.vmaxpool_time = vmaxpoolv_time;
alignment_pooled.vmaxpool_begining_ending = vmaxpoolv_begining_ending;
alignment_pooled.vmaxpool_window_cycle = vmaxpoolv_window_cycle;

alignment_pooled.dminpool_cell_marker = dminpool_cell_marker;
alignment_pooled.dmaxpool_cell_marker = dmaxpool_cell_marker;
alignment_pooled.vmaxpoolv_cell_marker = vmaxpoolv_cell_marker;
alignment.cellorder = inputFileList;
save(fullfile(pathname, 'alignment_pooled.mat'), 'alignment_pooled');
end