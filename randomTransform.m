function [transformedImage] = randomTransform(inputImage, rotationRange, scaleRange, toneRange)
% RANDOMTRANSFORM Randomly transforms an image with translation, rotation, and scale.
% inputImage: Input image to be transformed
% translationRange: Range for random translation, e.g., [-20, 20] pixels in x and y directions
% rotationRange: Range for random rotation in degrees, e.g., [-30, 30] degrees
% scaleRange: Range for random scaling, e.g., [0.8, 1.2]

% Apply random rotation
angle = randi(rotationRange);
rotatedImage = imrotate(translatedImage, angle, 'bicubic', 'loose');

% Apply random scaling
scaleFactor = scaleRange(1) + rand*(scaleRange(2)-scaleRange(1));
scaledImage = imresize(rotatedImage, scaleFactor,"bicubic");

toneFactor = toneRange(1) + rand*(toneRange(2)-toneRange(1));
hsv = rgb2hsv(scaledImage);
hsv(:,:,1) = hsv(:,:,1) * toneFactor;

transformedImage = hsv;
end