function imOut = lowpassSobel(imIn)
    % Define the Sobel kernels for horizontal and vertical edge detection
    sobelY = [-1, 0, 1; -2, 0, 2; -1, 0, 1];% Horizontal
    sobelX = [-1, -2, -1; 0, 0, 0; 1, 2, 1];% Vertical
    
    % Making sure im is in double form
    imIn = im2double(imIn);

    % Perform convolution with Sobel kernels to detect edges
    edgesY = conv2(imIn, sobelY, 'same');
    edgesX = conv2(imIn, sobelX, 'same');
    
    % Calculate the magnitude of the edges
    imOut = sqrt(edgesY.^2 + edgesX.^2);
    
    % Normalize the map to the range [0, 1]
    imOut = imOut./max(max(imOut));
end
