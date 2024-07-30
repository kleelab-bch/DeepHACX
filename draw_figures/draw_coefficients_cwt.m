function draw_coefficients_cwt(wavelet_coff, dist, cl)
%



%get the number of samples
num_sample = size(dist, 1);

%get the size of wavelet_coff.
[row, col] = size(wavelet_coff);

frame = row / num_sample;
figure
for i = 1 : num_sample
    imagesc(wavelet_coff((i-1) * frame + 1: i*frame,:));
    waitforbuttonpress 
end
end