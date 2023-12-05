function [eye1,eye2] = findEyes(imIn)
    % Perform color correction and automatic white balance
    imCorrected = contrastStretchColor(AWB(colorCorrection(imIn),1),0,1);
    %imCorrected = cat(3, 1.015*imCorrected(:,:,1), imCorrected(:,:,2), imCorrected(:,:,3));
    %size(imCorrected(:,:,1))
    %imshow(imCorrected);title('imCorrected')

    % Generate face masks based on different criteria
    maskSkin = skinMask2(imCorrected);
    maskThreshold = thresholdMask(imCorrected);
    maskSobel = sobelMask(imCorrected);
    SE = strel('disk', 4);
    maskSobel = imclose(maskSobel, SE);
    
    % Combine face masks using logical AND and OR operations
    maskA = maskSkin; %.* maskThreshold;
    %imshow(maskA); title('SkinMask')
    maskB = maskThreshold .* maskSobel;
    maskC = maskSkin .* maskSobel;
    mask = maskA | maskB | maskC;
    mask = imfill(mask, 'holes');
    %size(mask)
    %imshow(double(mask).*imIn); title('violaJones input')
    mask = violaJones(double(mask), imIn);
    %imshow(double(mask).*imIn);title('mask')

    SE = strel('disk', 10);
    mask = imclose(mask, SE);    
    mask = imclose(mask, SE);
    mask = imfill(mask, 'holes');
    %imshow(im2double(maskSkin).*im2double(imIn));title('mask')
    %imshow(mask)

    % Generate an eye map and dilate it
    map = dilationDisk(eyeMap(colorCorrection(imCorrected)), 6);
    %size(map)

    % Mask the eye map to the area where eyes can be
    %faceCorrected = im2double(imIn).*double(maskSkin);
    %imshow(faceCorrected);title('faceCorrected')
    %faceCorrected = contrastStretchColor(AWB(colorCorrection(faceCorrected),1),0,1);
    %map = map.*windowFromMouthMap(faceCorrected); %used for DB1 and woorks
    %but DB2 needs the more soficticated viola-jones alg for the window
    %imshow(im2double(imIn).*windowFromMouthMap(faceCorrected)); title('window');
    
    % Apply the combined face mask to the eye map
    filt = map.* mask;
    %imshow(filt); title('filt')

    centroidsAre2 = false;
    val = 0.0;
    while ~centroidsAre2
        try
        % Threshold the filtered map to keep only significant regions
        filtMask = max(max(filt)) * (0.8 - val) < filt; 
        filtMask = erodationDisk(filtMask,1);
        %imshow(filtMask); title('filtMask')
        filtMask = bwareafilt(filtMask, 2); % Keep only the two largest white regions
    
        filtMask = dilationDisk(filtMask, 8);
        % Label the connected components in the binary image
        labeled_image = bwlabel(filtMask);
        % imshow(filtMask); title('filtMask')
        % Calculate the region properties, including the centroids, of the labeled components
        stats = regionprops(logical(labeled_image), 'Centroid');
        
        % Extract the centroids of the circles
        centroid1 = stats(1).Centroid;
        centroid2 = stats(2).Centroid;
        centroidsAre2 = true;
        catch
            val = val + 0.1;
        end    
    end
    % Call a separate function to refine eye positions using circular Hough transform
    [eye1, eye2] = findEyesUsingCircularHough(imIn, centroid1, centroid2);
end
