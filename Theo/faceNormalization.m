function normalized_img = faceNormalization(img, eye1, eye2, targetSize)
    % Calculate the angle between the eyes
    angle = atan2(eye2(2) - eye1(2), eye2(1) - eye1(1));

    % Convert the angle from radians to degrees
    angle_degrees = rad2deg(angle);

    % Rotate the image to make the eyes horizontal
    rotated_img = imrotate(img, -angle_degrees, 'bilinear', 'crop');

    % Calculate the center of the eyes in the rotated image
    eye_center = [(eye1(1) + eye2(1)) / 2, (eye1(2) + eye2(2)) / 2];

    % Calculate the translation needed to center the eyes
    translation = round(size(rotated_img) / 2 - eye_center);

    % Translate the rotated image
    translated_img = imtranslate(rotated_img, translation, 'bilinear', 'FillValues', 0);

    % Resize the translated image to the target size
    normalized_img = imresize(translated_img, targetSize);

    % Display the original, rotated, translated, and normalized images for comparison
    figure;
    subplot(1, 4, 1), imshow(img), title('Original Image');
    subplot(1, 4, 2), imshow(rotated_img), title('Rotated Image');
    subplot(1, 4, 3), imshow(translated_img), title('Translated Image');
    subplot(1, 4, 4), imshow(normalized_img), title('Normalized Image');

    % Now you can proceed with any additional processing steps
end
