function mask = faceMask3(imIn)
    % Edge mask

    imGray = rgb2gray(imIn);
    
    sobX = [-1 -2 -1; 
             0 0 0; 
             1 2 1];
    
    sobY = [-1 0 1;
            -2 0 2; 
            -1 0 1];
    
    imSobelX = imfilter(imGray,sobX);
    imSobelY = imfilter(imGray,sobY);
    
    mask = sqrt(imSobelX.^2 + imSobelY.^2) > 0.5;

    mask = dilationDisk(mask,6);
    mask = dilationDisk(mask,6);
    mask = erodationDisk(mask,6);
    mask = erodationDisk(mask,6);
end
