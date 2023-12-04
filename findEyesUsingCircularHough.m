function [eye1,eye2] = findEyesUsingCircularHough(imIn, centroid1, centroid2)
    imIn = im2double(imIn);
    
    scaleFac = 3;

    imIn = imresize(imIn,scaleFac, 'bicubic');
    [n, m, ~] = size(imIn);
    centroid1 = centroid1 .*scaleFac;
    centroid2 = centroid2 .*scaleFac; 

    mask = zeros(n,m);
    
    eye1n = centroid1(1);
    eye1m = centroid1(2);
    eye2n = centroid2(1);
    eye2m = centroid2(2);
    
    mask(round((eye1m-scaleFac*25)):round((eye1m+scaleFac*25)), round(eye1n-scaleFac*25):round(eye1n+scaleFac*25)) = 1;
    mask(round((eye2m-scaleFac*25)):round((eye2m+scaleFac*25)), round(eye2n-scaleFac*25):round(eye2n+scaleFac*25)) = 1;
    %imshow(mask.*imIn); title('hough mask')

    imMask = imIn .* mask;
    imMask = imMask + ~mask;
    %imshow(imMask); title('Mask around centroids')
    try
        [centers, radii, ~] = imfindcircles(imMask,[8 300],'ObjectPolarity','dark');
        centersStrong2 = centers(1:2,:); 
        radiiStrong2 = radii(1:2);
        %viscircles(centersStrong2, radiiStrong2,'EdgeColor','b');
          
        eye1 = centers(1,:)/scaleFac;
        eye2 = centers(2,:)/scaleFac;
    catch exception
        %disp(['Error in findEyesUsingCircularHough: ' exception.message]);
        eye1 = centroid1/scaleFac;
        eye2 = centroid2/scaleFac;
        %imshow(imIn); title('Mask around centroids')
    end    
end