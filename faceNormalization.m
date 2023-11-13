function normalized_img = faceNormalization(img, eye1, eye2)
    % Calculate the angle between the eyes
    if eye1(1) > eye2(1)
        dummy = eye2;
        eye2 = eye1;
        eye1 = dummy;
    end
    angle = (atan2(eye2(2) - eye1(2), eye2(1) - eye1(1)));

    % Rotate the image to make the eyes horizontal
    rotated_img = imrotate(img, rad2deg(angle), 'bicubic', 'crop');
    
    % Calculate the center of the eyes in the rotated image
    eye_center = [(eye1(1) + eye2(1)) / 2, (eye1(2) + eye2(2)) / 2];


    %% Gör så distance_between_eyes är densamma för alla bilder, dvs skala om bilden

    % Calculate the distance between the eyes
    distance_between_eyes = norm(eye2 - eye1);

    % Calculate the cropping window
    crop_width = 50 + distance_between_eyes / 2;
    crop_height_above = 100;
    crop_height_below = 150;

    crop_x = round([eye_center(1) - crop_width, eye_center(1) + crop_width]);
    crop_y = round([eye_center(2) - crop_height_above, eye_center(2) + crop_height_below]);

    % Ensure the cropping window stays within the image boundaries
    crop_x = max(1, crop_x);
    crop_x = min(size(rotated_img, 2), crop_x);
    crop_y = max(1, crop_y);
    crop_y = min(size(rotated_img, 1), crop_y);

    % Crop the image with the fixed window
    cropped_img = rotated_img(crop_y(1):crop_y(2), crop_x(1):crop_x(2), :);


    % Return the normalized image without resizing
    normalized_img = cropped_img;
end
