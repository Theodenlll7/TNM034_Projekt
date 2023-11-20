function mask = faceMask1(imIn)
    
    imIn = im2uint8(imIn);
    imIn = AWB(imIn, 20);
    imIn = colorCorrection(imIn);
    imIn = AWB(imIn,0);
    imIn = contrastStretchColor(imIn,0,1);
    
    % Convert the RGB image to YCgCr color space
    ycgcrImage = rgb2ycgcr(imIn);
    
    % Extract the Y, Cb, and Cr channels
    Y = ycgcrImage(:, :, 1);
    Cg = ycgcrImage(:, :, 2);
    Cr = ycgcrImage(:, :, 3);
    
    % Define thresholds for skin color in YCbCr space
    % Trail and Error Values
    Ymin = 0.3;
    Ymax = 0.92;
    Cgmin = 0.3;
    Cgmax = 0.55;
    Crmin = 0.06;
    Crmax = 0.17;

    % Create binary masks for skin regions
    mask = (Ymin <= Y & Y <= Ymax) & (Cgmin <= Cg & Cg <= Cgmax) & (Crmin <= Cr & Cr <= Crmax);
    
    SE = strel('disk', 6);
    mask = imerode(mask, SE);
    mask = imclose(mask, SE);

    SE = strel('disk', 12);
    mask = imdilate(mask, SE);
    mask = imclose(mask, SE);

    % Filter image, retaining only the 5 objects with the largest areas.
    mask = bwareafilt(mask,1);    

    mask = imfill(mask, 'holes');
    %imshow(mask); title('mask')

end

function ycgcrImage = rgb2ycgcr(rgbImage)
    % Define the conversion matrix for RGB to YCgCr
    conversionMatrix = [0.299 0.587 0.114; -0.1687367 -0.331264 0.5; 0.5 -0.418688 -0.081312];
    
    % Convert the RGB image to YCgCr
    [rows, cols, ~] = size(rgbImage);
    ycgcrImage = zeros(rows, cols, 3);
    
    for i = 1:rows
        for j = 1:cols
            pixel = double(reshape(rgbImage(i, j, :), 3, 1));
            ycgcrPixel = conversionMatrix * pixel;
            ycgcrImage(i, j, :) = ycgcrPixel;
        end
    end

    % Normalize the YCgCr channels
    ycgcrImage(:, :, 2) = ycgcrImage(:, :, 2) + 0.5;
    ycgcrImage = min(max(ycgcrImage, 0), 1);
end

%% Old facemask1
% % YCbCr mask
%     imIn = im2uint8(imIn);
% 
%     % https://www.sciencedirect.com/science/article/pii/S1877050915018918
%     Y_min = 70;
%     Cb_Min = 100;
%     Cb_Max = 150;
%     Cr_Min = 120;
%     Cr_Max = 200;
% 
%     [n, m, ~] = size(imIn);
%     mask = zeros(n,m);
%     YCbCr = rgb2ycbcr(imIn);
% 
%     for i = 1:n
%         for j = 1:m
%             Y_ij = YCbCr(i,j,1); 
%             Cb_ij = YCbCr(i,j,2);
%             Cr_ij = YCbCr(i,j,3);
%             if((Y_min < Y_ij) && (Cb_Min <= Cb_ij && Cb_ij <= Cb_Max ) && (Cr_Min <= Cr_ij && Cr_ij <= Cr_Max))
%                 mask(i,j) = 1;% if we find skin
%             end
%         end
%     end     
%     mask = imfill(mask, 'holes');
% 
%     mask = dilationDisk(mask,5);
%     mask = dilationDisk(mask,5);
%     mask = imfill(mask, 'holes');
%     mask = erodationDisk(mask,4);
%     mask = erodationDisk(mask,4);

