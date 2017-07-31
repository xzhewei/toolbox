% mex SegByDualthresholdY.c
Is = seqIo('20131206-173911.seq','toImgs');
img = Is(:,:,:,50);
img = rgb2gray(img);
% n = 0:255;
% n = reshape(n,8,32);
% n = uint8(n);

[ri,ro] = SegByDualthresholdY(img,[],576,720);
ri8 = uint8(ri);
ro8 = uint8(ro);
figure;
subplot(1,3,1);
imshow(img);
subplot(1,3,2);
imshow(ri8);
subplot(1,3,3);
imshow(ro8);

