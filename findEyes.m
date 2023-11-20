function [eye1,eye2] = findEyes(imIn)
    % Perform color correction and automatic white balance
    imCorrected = contrastStretchColor(AWB(colorCorrection(imIn),1),0,1);

    % Generate face masks based on different criteria
    maskSkin = skinMask(imCorrected);
    maskThreshold = thresholdMask(imCorrected);
    maskSobel = sobelMask(imCorrected);
    
    % Combine face masks using logical AND and OR operations
    maskA = maskSkin .* maskThreshold;
    maskC = maskSkin .* maskSobel;
    maskB = maskThreshold .* maskSobel;
    mask = maskA | maskB | maskC;
    mask = imfill(mask, 'holes');

    % Generate an eye map and dilate it
    map = dilationDisk(eyeMap(colorCorrection(imCorrected)), 6);

    % Mask the eye map to the area where eyes can be
    faceCorrected = im2double(imIn).*double(maskSkin);
    faceCorrected = contrastStretchColor(AWB(colorCorrection(faceCorrected),1),0,1);
    map = map .* windowFromMouthMap(faceCorrected);
    imshow(im2double(imIn).*windowFromMouthMap(faceCorrected)); title('window');
    
    % Apply the combined face mask to the eye map
    filt = map .* mask;

    % Threshold the filtered map to keep only significant regions
    filtMask = max(max(filt)) * 0.8 < filt;
    filtMask = erodationDisk(filtMask,1);

    filtMask = bwareafilt(filtMask, 2); % Keep only the two largest white regions

    filtMask = dilationDisk(filtMask, 8);

    % Label the connected components in the binary image
    labeled_image = bwlabel(filtMask);
    
    % Calculate the region properties, including the centroids, of the labeled components
    stats = regionprops(logical(labeled_image), 'Centroid');
    
    % Extract the centroids of the circles
    centroid1 = stats(1).Centroid;
    centroid2 = stats(2).Centroid;
    
    % Call a separate function to refine eye positions using circular Hough transform
    [eye1, eye2] = findEyesUsingCircularHough(imIn, centroid1, centroid2);
end
