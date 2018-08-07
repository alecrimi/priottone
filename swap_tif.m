fname = '-198000_000000_420000.tif';
info = imfinfo(fname);
num_images = numel(info);

temp = imread(fname);
[r,c] = size(temp);
A = zeros(r,c,num_images);

% Load data
for k = 1:num_images
    A(:,:,k) = imread(fname, k);
end

% invert order
A = flip(A,3);
% Swap top and down
A = flipud(A);

% save file
options.comp = 'adobe';
A = uint16(A);
saveastiff(A, 'stack_compress.tif', options);