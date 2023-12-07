function imOut = colorCorrection(imIn)
    % Function for color correction and automatic white balance (AWB)
    imIn = im2double(imIn);

    imR = imIn(:,:,1);
    imG = imIn(:,:,2);
    imB = imIn(:,:,3);

    [m, n, ~] = size(imIn);

    avgR = 1 / (m * n) * sum(sum(imR)); 
    avgG = 1 / (m * n) * sum(sum(imG)); 
    avgB = 1 / (m * n) * sum(sum(imB));

    maxR = max(max(imR));
    maxG = max(max(imG));
    maxB = max(max(imB));
    maxRGB = max(max(maxR,maxG),maxB);

    % Perform color correction by scaling the channels
    imR = imR * (avgR / maxRGB);
    imG = imG * (avgG / maxRGB);
    imB = imB * (avgB / maxRGB);

    imOut(:,:,1) = imR;
    imOut(:,:,2) = imG;
    imOut(:,:,3) = imB;
end
