list = dir('*.tif');

test_im = imread(list(1).name);

[r,c] = size(test_im);
datamat = zeros(r,c,length(list));

for kk = 1 : length(list)
   
    kk
    datamat(:,:,kk) = imread(list(kk).name);
    
end
options.comp = 'adobe';
datamat = uint16(datamat);
saveastiff(datamat, 'stack_compress.tif', options);