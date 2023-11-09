function imOut = colorCorrection(imIn)
    % Function for color correction and automatic white balance (AWB)
    imIn = im2double(imIn);
    % Initialize the output image with the input image
    imOut = imIn;

    % Extract the red, green, and blue channels from the input image
    imR = imIn(:,:,1);
    imG = imIn(:,:,2);
    imB = imIn(:,:,3);

    % Get the dimensions of the input image
    [m, n, ~] = size(imIn);

    % Calculate the average values of the red, green, and blue channels
    avgR = 1 / (m * n) * sum(sum(imR)); 
    avgG = 1 / (m * n) * sum(sum(imG)); 
    avgB = 1 / (m * n) * sum(sum(imB));

    % Find the maximum values in the red, green, and blue channels
    maxR = max(max(imR));
    maxG = max(max(imG));
    maxB = max(max(imB));

    % Perform color correction by scaling the channels
    imR = imR * (avgR / maxR);
    imG = imG * (avgG / maxG);
    imB = imB * (avgB / maxB);

    % Update the output image with the corrected color channels
    imOut(:,:,1) = imR;
    imOut(:,:,2) = imG;
    imOut(:,:,3) = imB;
end
