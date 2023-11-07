function imOut = dilationDisk(imIn, size)
    % Function to perform dilation on a binary image using a square structuring element
    % Create a square structuring element with the specified size
    SE = strel('square', size);

    % Perform dilation on the binary image with the square structuring element
    imOut = imdilate(imIn, SE);
end