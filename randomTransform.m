function [transformedImage] = randomTransform(inputImage, rotationRange, scaleRange, toneRange)
% RANDOMTRANSFORM Randomly transforms an image with translation, rotation, and scale.
% inputImage: Input image to be transformed
% rotationRange: Range for random rotation in degrees, e.g., [-30, 30] degrees
% scaleRange: Range for random scaling, e.g., [0.8, 1.2]
% toneRange: Range for adjusting image tone, e.g., [0.5, 1.5]

% Save input image dimensions
inputSize = size(inputImage);

% Apply random rotation
angle = randi(rotationRange);
rotatedImage = imrotate(inputImage, angle, 'bicubic', 'loose');

% Apply random scaling
scaleFactor = scaleRange(1) + rand * (scaleRange(2) - scaleRange(1));
scaledImage = imresize(rotatedImage, scaleFactor, 'bicubic');

% Adjust image tone
toneFactor = toneRange(1) + rand * (toneRange(2) - toneRange(1));
ycbcrImg = rgb2ycbcr(scaledImage);
ycbcrImg(:, :, 1) = ycbcrImg(:, :, 1) .* toneFactor;

transformedImage = ycbcr2rgb(ycbcrImg);

% Resize the transformed image to match the input image size
transformedImage = imresize(transformedImage, inputSize(1:2));

end