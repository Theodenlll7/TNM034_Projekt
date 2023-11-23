function imOut = windowFromMouthMap(imIn)
    % Convert the RGB image to the YCbCr color space
    ycbcr_image = rgb2ycbcr(imIn);
    
    % Extract the Y, Cb, and Cr components
    Y = im2double(ycbcr_image(:, :, 1));
    Cb = im2double(ycbcr_image(:, :, 2));
    Cr = im2double(ycbcr_image(:, :, 3));
    
    % Mouth Detection
    n = 0.95 * mean(mean(Cr.^2)) / mean(mean(Cr./Cb));
    mouthMap = Cr.^2 .* (Cr.^2 - n.*Cr./Cb).^2;
    mouthMap = (mouthMap./max(max(mouthMap))); % histeq
    mouthMap = dilationDisk(mouthMap,12);

    noiseSE = strel('disk',2);
    blobsSE = strel('disk',5);
    vertLineSE = strel('line', 6, 0); % 0 deg

    mouthMap = imopen(mouthMap, noiseSE); % From lab4 (Boben)
    mouthMap = imopen(mouthMap, vertLineSE);
    mouthMap = imclose(mouthMap, blobsSE);
    %imshow(mouthMap); title('mouthMap1')

    
    mouthMap = max(max(mouthMap)).*0.8 < mouthMap; 
    %imshow(mouthMap); title('mouthMap2')

    mouthMap = imfill(mouthMap, 'holes');
    mouthMap = bwareafilt(mouthMap, 1);% Sparar bara det största området
    %imshow(mouthMap); title('mouthMap3')
    

    % Mouth eegion extraction
    labeled_image = bwlabel(mouthMap);
    stats = regionprops(logical(labeled_image), 'Centroid');
    ce = stats(1).Centroid;

    % Mask creation
    [n, m, ~] = size(imIn);
    mask = zeros(n,m);
    
    mask(round((ce(2)-1.0*n/3)):round((ce(2)-0.2*n/3)), round(ce(1)-m/4):round(ce(1)+m/4),1) = 1;
    %imshow(mask); title('mask')

    try
    % Perform erodation on the binary image with the disk structuring element
    SE = strel('line', 10, 90);
    mouthMap = imerode(mouthMap, SE);
    % imshow(mouthMap); title('mouthMap')

    grayImg = im2double(mouthMap);
    edgeImg = edge(grayImg, 'canny');
    [H, theta, rho] = hough(edgeImg);
    peaks = houghpeaks(H, 10);
    lines = houghlines(edgeImg, theta, rho, peaks);
    
    angles = [lines.theta];
    rotAngle = 90 - angles(1);

    % Final Output, a masked version of the input
    imOut = mask;
    %imOut = imrotate(mask,rotAngle,'bicubic', 'crop');
    catch exception
        %disp(['Error in angle transform (windowFromMouthMap): ' exception.message]);
        imOut = mask;
    end    
        %imshow(imOut.*imIn); title('imOut mouthMap')
        %imshow(imIn.*mouthMap); title('mouth')
end