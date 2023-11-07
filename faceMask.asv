function mask = faceMask(imIn)
    imIn = im2double(imIn).*255;

    R = imIn(:,:,1);
    G = imIn(:,:,2);
    B = imIn(:,:,3);
    
    [H, S, ~] = rgb2hsv(imIn);
    mask = (0 <= H & H <= 50) & (0.23 <= S & S <= 0.68) & (95 < R) & (40 < G) & (20 < B) & (G < R) & (B < R) & (15 < abs(R - G));
    mask = imfill(mask, 'holes');

    mask = dilationDisk(mask,2);
    mask = erodationDisk(mask,3);
    mask = dilationDisk(mask,4);

    mask = imfill(mask, 'holes');
end
