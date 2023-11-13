function normalized_img = faceNormalization(img, eye1, eye2)
    % Calculate the angle between the eyes
    angle = atan2(eye2(2) - eye1(2), eye2(1) - eye1(1));

    % Convert the angle from radians to degrees
    angle_degrees = rad2deg(angle);

    % Rotate the image to make the eyes horizontal
    rotated_img = imrotate(img, angle_degrees, 'bilinear', 'crop');
    
    % Calculate the center of the eyes in the rotated image
    eye_center = [(eye1(1) + eye2(1)) / 2, (eye1(2) + eye2(2)) / 2];
 

    % Calculate the translation needed to center the eyes
    translation = round(abs(size(rotated_img(:,:,1)) / 2 - eye_center));

    % Translate the rotated image
    translated_img = imtranslate(rotated_img, translation, 'bilinear', 'FillValues', 255);

    % Crop the translated image to ensure a consistent size
    [rows, cols, ~] = size(img);
    cropped_img = imcrop(translated_img, [1, 1, cols - 1, rows - 1]);

    % Display the original, rotated, translated, and normalized images for comparison
    %figure;
    %subplot(1, 4, 1), imshow(img), title('Original Image');
    %subplot(1, 4, 2), imshow(rotated_img), title('Rotated Image');
    %subplot(1, 4, 3), imshow(translated_img), title('Translated Image');
    %subplot(1, 4, 4), imshow(cropped_img), title('Cropped Image');

    % Return the normalized image without resizing
    cropped_img = drawX(cropped_img, eye_center(1), eye_center(2));
    normalized_img = cropped_img;
end
