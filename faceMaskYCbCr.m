function mask = faceMaskYCbCr(imIn)
    imYCbCr = rgb2ycbcr(im2double(imIn))*255;

    % Extract the Y, Cb, and Cr channels as double-precision values
    Y = im2double(imYCbCr(:, :, 1));
    Cb = im2double(imYCbCr(:, :, 2));
    Cr = im2double(imYCbCr(:, :, 3));

    Ymin = 70;
    cbMin = 110;
    cbMax = 180;
    crMin = 129;
    crMax = 185;
    
    mask = (Ymin < Y) & (cbMin < Cb & Cb < cbMax) & (crMin < Cr & Cr < crMax);
    mask = imfill(mask, 'holes');

    mask = dilationDisk(mask,2);
    mask = erodationDisk(mask,3);
    mask = dilationDisk(mask,4);

    mask = imfill(mask, 'holes');
end
