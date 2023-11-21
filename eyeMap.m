function [imYCbCr] = eyeMap(imRGBdouble)
    % Summurazation: Function to calculate the eye map from an RGB image
    imYCbCr = rgb2ycbcr(imRGBdouble);

    % Extract the Y, Cb, and Cr channels as double-precision values
    Y = im2double(imYCbCr(:, :, 1));
    Cb = im2double(imYCbCr(:, :, 2));
    Cr = im2double(imYCbCr(:, :, 3));

    % Calculate the eye map by multiplying C-based and L-based eye maps
    % Se: "Face Detection in Color Images"
    imYCbCr = eyeMapL(Y) .* eyeMapC(Cb, Cr);


    % Find the current minimum and maximum values in eyeMapL
    minVal = min(min(imYCbCr));
    maxVal = max(max(imYCbCr));

    % Apply contrast stretching
    imYCbCr = ((imYCbCr - minVal) * ((maxVal - minVal) / (maxVal - minVal)) + minVal);
    
    imYCbCr = dilationDisk(imYCbCr, 6);
    imYCbCr = dilationDisk(imYCbCr, 8);
    imYCbCr = dilationDisk(imYCbCr, 10);

    
    imshow(imYCbCr); title('imYCbCr')
end

% Function to calculate the chromaticity-based eye map
function [eyeMapC] = eyeMapC(Cb, Cr)
    % Calculate the chromaticity-based eye map using Cb and Cr channels
    eyeMapC = 1/3 * (Cb.^2 + (1 - Cr.^2) + Cb./Cr);

    % Improves the contrast of the map (not necessary for L)
    eyeMapC = histeq(eyeMapC);

    % Normalize the map to the range [0, 1]
    eyeMapC = eyeMapC./max(max(eyeMapC));
end

% Function to calculate the luminance-based eye map
function [eyeMapL] = eyeMapL(Y)
    % Define a structuring element for dilation (morphological operation)
    SE = strel('disk', 12);  % Adjust the size as needed

    % Calculate the luminance-based eye map using dilation and erosion
    eyeMapL = double(imdilate(Y, SE)./(imerode(Y, SE) + 1));

     % Normalize the map to the range [0, 1]
     eyeMapL = eyeMapL./max(max(eyeMapL));
end