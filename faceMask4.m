function mask = faceMask4(imIn)
    jm = rgb2lab(imIn);
    vm = mat2gray(jm(:,:,3));
    bw = im2bw(vm);
    im2 = imIn;
    im2(~cat(3,bw,bw,bw)) = 255;
    mask = mat2gray(im2); 
    mask = rgb2gray(mask);
end
