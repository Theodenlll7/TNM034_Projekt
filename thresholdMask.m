function mask = thresholdMask(imIn)
    % threshold mask or color mask

    imIn = AWB(imIn,6);
    imGray = rgb2gray(imIn);

    mask = imGray > 0.6;    

    mask = dilationDisk(mask,6);
    mask = dilationDisk(mask,6);
    mask = erodationDisk(mask,6);
    mask = erodationDisk(mask,6);
end
