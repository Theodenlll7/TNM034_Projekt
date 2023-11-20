function imOut = eyesWindow(imIn)
    % Convert the RGB image to the YCbCr color space
    ycbcr_image = rgb2ycbcr(imIn);
    
    % Extract the Y, Cb, and Cr components
    Y = im2double(ycbcr_image(:, :, 1));
    Cb = im2double(ycbcr_image(:, :, 2));
    Cr = im2double(ycbcr_image(:, :, 3));
    
    % Mouth Detection
    n = 0.95 * mean(mean(Cr.^2)) / mean(mean(Cr./Cb));
    mouthMap = Cr.^2 .* (Cr.^2 - n.*Cr./Cb).^2;
    mouthMap = mouthMap./max(max(mouthMap));
    mouthMap = dilationDisk(mouthMap,12);
    mouthMap = max(max(mouthMap)).*0.4 < mouthMap; 
    mouthMap = imfill(mouthMap, 'holes');
    mouthMap = bwareafilt(mouthMap, 1);% Sparar bara det största området

    % Mouth eegion extraction
    labeled_image = bwlabel(mouthMap);
    stats = regionprops(logical(labeled_image), 'Centroid');
    ce = stats(1).Centroid;

    % Mask creation
    [n, m, ~] = size(imIn);
    mask = zeros(n,m);
    
    mask(round((ce(2)-1.1*n/3)):round((ce(2)-1.2*n/9)), round(ce(1)-m/4):round(ce(1)+m/4),1) = 1;
    
    % Final Output, a masked version of the input
    imOut = mask;
end