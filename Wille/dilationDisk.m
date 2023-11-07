function imOut = dilationDisk(imIn, size)
    % Function to perform dilation on a binary image using a disk structuring element
    SE = strel('square', size);

    % Perform dilation on the binary image with the disk structuring element
    imOut = imdilate(imIn, SE);
end