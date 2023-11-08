function mask = faceMask1(imIn)
% YCbCr mask
    imIn = im2uint8(imIn);

    % https://www.sciencedirect.com/science/article/pii/S1877050915018918
    Y_min = 70;
    Cb_Min = 100;
    Cb_Max = 150;
    Cr_Min = 120;
    Cr_Max = 200;

    [n, m, ~] = size(imIn);
    mask = zeros(n,m);
    YCbCr = rgb2ycbcr(imIn);

    for i = 1:n
        for j = 1:m
            Y_ij = YCbCr(i,j,1); 
            Cb_ij = YCbCr(i,j,2);
            Cr_ij = YCbCr(i,j,3);
            if((Y_min < Y_ij) && (Cb_Min <= Cb_ij && Cb_ij <= Cb_Max ) && (Cr_Min <= Cr_ij && Cr_ij <= Cr_Max))
                mask(i,j) = 1;% if we find skin
            end
        end
    end     
    mask = imfill(mask, 'holes');

    mask = dilationDisk(mask,5);
    mask = dilationDisk(mask,5);
    mask = imfill(mask, 'holes');
    mask = erodationDisk(mask,4);
    mask = erodationDisk(mask,4);

end
