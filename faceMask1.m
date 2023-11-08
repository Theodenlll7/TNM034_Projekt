function mask = faceMask1(imIn)
    imIn = im2uint8(imIn);

    R = imIn(:,:,1);
    G = imIn(:,:,2);
    B = imIn(:,:,3);
    
    [H, S, ~] = rgb2hsv(imIn);

    % ==========================================================================================
    % INTE VÅRAN KOD --> HITTA ANNAN METOD
    % threshold values obtained after testing
    Y_min = 70;
    Cb_Min = 110;
    Cb_Max = 180;
    Cr_Min = 129;
    Cr_Max = 185;

    [n, m, ~] = size(imIn);
    im = zeros(n,m);
    YCbCr = rgb2ycbcr(imIn);

    for i = 1:size(im,1)
        for j = 1:size(im, 2)
            Y = YCbCr(i,j,1); 
            Cb = YCbCr(i,j,2);
            Cr = YCbCr(i,j,3);
            if((Y > Y_min) && (Cb_Min <= Cb && Cb <= Cb_Max ) && (Cr_Min <= Cr && Cr <= Cr_Max))
                im(i,j) = 1;  %found face-skin
            end
        end
    end 
    % ==========================================================================================
    mask = (0 <= H & H <= 60) & (0.23 <= S & S <= 0.68) & (95 < R) & (40 < G) & (20 < B) & (G < R) & (B < R) & (15 < abs(R - G));
    
    mask = im;% GÖR SÅ VI INTE ANVÄNDER VÅRAN KOD

    mask = imfill(mask, 'holes');

    mask = dilationDisk(mask,5);
    mask = dilationDisk(mask,5);
    mask = imfill(mask, 'holes');
    mask = erodationDisk(mask,4);
    mask = erodationDisk(mask,4);

end
