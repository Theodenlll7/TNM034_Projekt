function imOut = erodationDisk(imIn, size)
   % Function to perform erodation on a binary image using a disk structuring element
    % Create a square structuring element with the specified size
    SE = strel('disk', size);

    % Perform erodation on the binary image with the disk structuring element
    imOut = imerode(imIn, SE);
end