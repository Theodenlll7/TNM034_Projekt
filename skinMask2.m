function mask = skinMask2(imIn)
%imIn = im2double(imread("Faces/db1_" + 3 + ".jpg"));
imIn = im2double(imIn);
imIn = adjustRGB(imIn);
%imIn = colorCorrection(imIn);
imIn = contrastStretchColor(imIn,0,1);
hsv = rgb2hsv(imIn);
ycbcr = rgb2ycbcr(imIn);


% Convert the RGB image to YCgCr color space
ycgcrImage = rgb2ycgcr(imIn);

% Extract the Y, Cb, and Cr channels
Y = ycgcrImage(:, :, 1);
Cg = ycgcrImage(:, :, 2);
Cr = ycgcrImage(:, :, 3);

Cb = histeq(ycbcr(:,:,2));

H = hsv(:,:,1);
% Define thresholds for skin color in YCbCr space
% Trail and Error Values

Cbmin = .28;
Cbmax = 0.75;

Ymin = .55;
Ymax = 1;

Cgmin = .4;
Cgmax = .545;
Crmin = 0.0015;
Crmax = 0.2;

Hmin = 0.09;
Hmax = 0.8;

cbmask = ~(Cbmin <= Cb & Cb <= Cbmax);
SE = strel('disk', 6);
cbmask = imerode(cbmask, SE);
cbmask = imclose(cbmask, SE);

SE = strel('disk', 19);% was 8 before 2023-11-22
cbmask = imdilate(cbmask, SE);
cbmask = imclose(cbmask, SE);

% Filter image, retaining only the 5 objects with the largest areas.
SE = strel('disk', 50);
cbmask = imclose(cbmask, SE);
cbmask = keepNLargestObjects(cbmask, 3);

cbmask = imfill(cbmask, 'holes');
SE = strel('disk', 10);
cbmask = imdilate(cbmask, SE);


crmask = (Crmin <= Cr & Cr <= Crmax);
SE = strel('disk', 2);
crmask = imclose(crmask, SE);
SE = strel('disk', 12);
crmask = imerode(crmask, SE);
SE = strel('rectangle', [80 5]);
crmask = imclose(crmask, SE);
SE = strel('rectangle', [80 5]);
crmask = imopen(crmask, SE);
SE = strel('rectangle', [5 10]);
crmask = imopen(crmask, SE);
crmask = imfill(crmask, 'holes');
crmask = keepNLargestObjects(crmask, 3);

%SE = strel('disk', 40);
%crmask = imopen(crmask, SE);
%imshow(crmask); title('crmask')

cgmask = (Cgmin <= Cg & Cg <= Cgmax);
%imshow(cgmask); title('cgmask')

ymask = (Ymin <= Y & Y <= Ymax);
SE = strel('disk', 24);
ymask = imdilate(ymask, SE);
ymask = imfill(ymask, 'holes');
ymask = keepNLargestObjects(ymask, 3);

hmask = (H <= Hmin | Hmax <= H);
SE = strel('disk', 6);
hmask = imerode(hmask, SE);
hmask = imclose(hmask, SE);

SE = strel('disk', 19);% was 8 before 2023-11-22
hmask = imdilate(hmask, SE);
hmask = imclose(hmask, SE);

% Filter image, retaining only the 5 objects with the largest areas.
SE = strel('disk', 50);
hmask = imclose(hmask, SE);
hmask = keepNLargestObjects(hmask, 3);

hmask = imfill(hmask, 'holes');
SE = strel('disk', 10);
hmask = imdilate(hmask, SE);

mask = crmask & cbmask & hmask & ymask;
%imshow(mask); title("mask")
% Create binary masks for skin regions
mask = keepNLargestObjects(mask, 2);
SE = strel('rectangle', [100 260]);
mask = imclose(mask, SE);
SE = strel('rectangle', [100 5]);
mask = imclose(mask, SE);
SE = strel('rectangle', [250 1]);
mask = imopen(mask, SE);
mask = keepNLargestObjects(mask, 1);
end