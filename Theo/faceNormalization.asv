function faceNormalization(img, eye1, eye2)
    % Calculate the angle between the eyes
    angle = atan2(eye2(2) - eye1(2), eye2(1) - eye1(1));

    % Convert the angle from radians to degrees
    angle_degrees = rad2deg(angle);

    % Rotate the image to make the eyes horizontal
    rotated_img = imrotate(img, -angle_degrees, 'bilinear', 'crop');

    % Display the original and rotated images for comparison
    figure;
    subplot(1, 2, 1), imshow(img), title('Original Image');
    subplot(1, 2, 2), imshow(rotated_img), title('Rotated Image');

    % Now you can proceed with further normalization steps
end