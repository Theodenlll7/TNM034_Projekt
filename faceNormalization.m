function imgNormalized = faceNormalization(img, eye1, eye2)
    %% Translation
    % Specify the desired center coordinates
    desiredCenter =  [(eye1(1) + eye2(1)) / 2, (eye1(2) + eye2(2)) / 2];
    
    % Calculate the displacement from the current center to the desired center
    currentCenter = [size(img, 2)/2, size(img, 1)/2]; % Current center of the image
    translationVector = round(desiredCenter - currentCenter);
    
    % Translate the image
    imgTranslated = imtranslate(img, translationVector);
    
    % Translate the point coordinates
    eye1 = eye1 + translationVector;
    eye2 = eye2 + translationVector;

    %% Rotation
    % Calculate the angle between the eyes
    if eye1(1) > eye2(1)
        dummy = eye2;
        eye2 = eye1;
        eye1 = dummy;
    end
    angle = (atan2(eye2(2) - eye1(2), eye2(1) - eye1(1)));

    % Rotate the image to make the eyes horizontal
    rotated_img = imrotate(imgTranslated, rad2deg(angle), 'bicubic', 'crop');
    
    %% Scale
    % Calculate the center of the eyes in the rotated image
    currentDistance = sqrt((eye2(1) - eye1(1))^2 + (eye2(2) - eye1(2))^2);
    
    % Specify the desired distance between the two pixels after scaling
    desiredDistance = 120;
    
    % Calculate the scale factor
    scaleFactor = desiredDistance / currentDistance;
    
    % Scale the image
    scaledImage = imresize(rotated_img, scaleFactor);
    
    % Scale the pixel coordinates
    eye1 = round(eye1 * scaleFactor);
    eye2 = round(eye2 * scaleFactor);

    %% Crop
    eye_center = [(eye1(1) + eye2(1)) / 2, (eye1(2) + eye2(2)) / 2];

    % % Calculate the cropping window
    % cropWidth = 50 + 120 / 2;
    % cropHeightAbove = 100;
    % cropHeightBelow = 150;
    % 
    % cropX = round([eye_center(1) - cropWidth, eye_center(1) + cropWidth]);
    % cropY = round([eye_center(2) - cropHeightAbove, eye_center(2) + cropHeightBelow]);
    % 
    % % Ensure the cropping window stays within the image boundaries
    % cropX = max(1, cropX);
    % cropX = min(size(scaledImage, 2), cropX);
    % cropY = max(1, cropY);
    % cropY = min(size(scaledImage, 1), cropY);
    % 
    % % Crop the image with the fixed window
    % imgCropped = scaledImage(cropY(1):cropY(2), cropX(1):cropX(2), :);
    % 
    % % Return the normalized image without resizing
    % imgNormalized = contrastStretchColor(AWB(colorCorrection(imgCropped),1),0,1);

    % Calculate the cropping window
cropWidth = 50 + 120 / 2;
cropHeightAbove = 100;
cropHeightBelow = 150;

cropX = round([eye_center(1) - cropWidth, eye_center(1) + cropWidth]);
cropY = round([eye_center(2) - cropHeightAbove, eye_center(2) + cropHeightBelow]);

% Get image dimensions
imgHeight = size(scaledImage, 1);
imgWidth = size(scaledImage, 2);

% Calculate required padding
padLeft = max(0, 1 - cropX(1));
padRight = max(0, cropX(2) - imgWidth);
padTop = max(0, 1 - cropY(1));
padBottom = max(0, cropY(2) - imgHeight);

% Pad the image while keeping track of the updated eye center
paddedImage = padarray(scaledImage, [padTop, padLeft], 0, 'pre');
paddedImage = padarray(paddedImage, [padBottom, padRight], 0, 'post');

% Adjust crop window for the padded image
paddedCropX = cropX + [padLeft, padLeft];
paddedCropY = cropY + [padTop, padTop];

% Crop the padded image
imgCropped = paddedImage(paddedCropY(1):paddedCropY(2), paddedCropX(1):paddedCropX(2), :);

% Return the normalized image without resizing
imgNormalized = contrastStretchColor(AWB(colorCorrection(imgCropped),1), 0, 1);

    %% Color
    imgNormalized = rgb2gray(imgNormalized);
    imgNormalized = histeq(imgNormalized);
end
