function [transformedImage] = randomTransform(inputImage, translationRange, rotationRange, scaleRange)
% RANDOMTRANSFORM Randomly transforms an image with translation, rotation, and scale.
% inputImage: Input image to be transformed
% translationRange: Range for random translation, e.g., [-20, 20] pixels in x and y directions
% rotationRange: Range for random rotation in degrees, e.g., [-30, 30] degrees
% scaleRange: Range for random scaling, e.g., [0.8, 1.2]

% Apply random translation
tx = randi(translationRange);
ty = randi(translationRange);
translatedImage = imtranslate(inputImage, [tx, ty]);

% Apply random rotation
angle = randi(rotationRange);
rotatedImage = imrotate(translatedImage, angle, 'bicubic', 'loose');

% Apply random scaling
scaleFactor = scaleRange(1) + rand*(scaleRange(2)-scaleRange(1))
scaledImage = imresize(rotatedImage, scaleFactor,"bicubic");

transformedImage = scaledImage;
end