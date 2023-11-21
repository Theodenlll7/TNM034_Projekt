function croppedImage = skin_detection_and_crop(image_path)
    % Read the image
    image = imread(image_path);

    % Convert the image to the RGB color space
    rgbImage = image;

    % Extract the color channels
    redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    blueChannel = rgbImage(:, :, 3);

    % Set thresholds for skin color in RGB space
    % These values can be adjusted based on your image characteristics
    redThreshold = 150;
    greenThreshold = 100;
    blueThreshold = 80;

    % Create a binary mask for skin pixels
    skinMask = (redChannel > redThreshold) & (greenChannel > greenThreshold) & (blueChannel > blueThreshold);

    % Use morphological operations to clean up the mask
    se = strel('disk', 15); % Adjust the disk size based on your image characteristics
    cleanedSkinMask = imopen(skinMask, se);

    % Find connected components in the cleaned mask
    cc = bwconncomp(cleanedSkinMask);

    % Identify the largest connected component (skin region)
    [~, idx] = max(cellfun(@numel, cc.PixelIdxList));
    largestComponentMask = false(size(cleanedSkinMask));
    largestComponentMask(cc.PixelIdxList{idx}) = true;

    % Use face detection to find the bounding box of the face
    faceDetector = vision.CascadeObjectDetector('MinSize', [50, 50], 'MaxSize', [500, 500]);
    bbox = step(faceDetector, rgbImage);

    % Filter out regions with extreme aspect ratios
    aspectRatioThreshold = 2.5;
    validIdx = abs(bbox(:, 3)./bbox(:, 4) - 1) < aspectRatioThreshold;
    bbox = bbox(validIdx, :);

    % Display the original image, skin mask, and zoomed-in face
    figure;

    subplot(1, 3, 1);
    imshow(rgbImage);
    title('Original Image');

    subplot(1, 3, 2);
    imshow(skinMask);
