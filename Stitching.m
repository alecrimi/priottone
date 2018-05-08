function Stitching(fname)

fname = 'mNS_terminal_rostral_DatCre-Ai6_A4P1_647ex_Triple_lp7_rightL_1x_10umStep(405).tif';
info = imfinfo(fname);
num_images = numel(info);
for k = 1:num_images
    A = imread(fname, k);
    FILENAME = strcat(int2str(k), '.tif')
    imwrite(A,FILENAME )
end
