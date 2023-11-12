function normalized_img = faceNormalizationWithMask(img, skinMask, eye1, eye2, targetSize)
    % Calculate the angle between the eyes
    angle = atan2(eye2(2) - eye1(2), eye2(1) - eye1(1));

    % Convert the angle from radians to degrees
    angle_degrees = rad2deg(angle);

    % Rotate the skin mask to make the eyes horizontal
    rotated_mask = imrotate(skinMask, -angle_degrees, 'bilinear', 'crop');

    % Find the bounding box of the skin region
    [row, col] = find(rotated_mask > 0);
    bbox = [min(col), min(row), max(col) - min(col), max(row) - min(row)];

    % Crop the original image and rotated mask based on the bounding box
    cropped_img = imcrop(img, bbox);
    cropped_mask = imcrop(rotated_mask, bbox);

    % Resize the cropped image and mask to the target size
    normalized_img = imresize(cropped_img, targetSize);
    normalized_mask = imresize(cropped_mask, targetSize);

    % Display the original, rotated, and normalized images for comparison
    figure;
    subplot(1, 4, 1), imshow(img), title('Original Image');
    subplot(1, 4, 2), imshow(rotated_mask), title('Rotated Skin Mask');
    subplot(1, 4, 3), imshow(cropped_img), title('Cropped Image');
    subplot(1, 4, 4), imshow(normalized_img), title('Normalized Image');

    % Now you can proceed with any additional processing steps
end
