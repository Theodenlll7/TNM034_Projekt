function [eye1,eye2] = findEyesUsingCircularHough(imIn, centroid1, centroid2)
    imIn = im2double(imIn);
    try
        [n, m, ~] = size(imIn);
        mask = zeros(n,m);
        
        eye1n = centroid1(1);
        eye1m = centroid1(2);
        eye2n = centroid2(1);
        eye2m = centroid2(2);
        
        mask(round((eye1m-25)):round((eye1m+25)), round(eye1n-25):round(eye1n+25)) = 1;
        mask(round((eye2m-25)):round((eye2m+25)), round(eye2n-25):round(eye2n+25)) = 1;
        
        
        imMask = imIn .* mask;
        imMask = imMask + ~mask;
        %imshow(imMask); title('Mask around centroids')
        
        [centers, radii, ~] = imfindcircles(imMask,[8 200],'ObjectPolarity','dark');
        centersStrong2 = centers(1:2,:); 
        radiiStrong2 = radii(1:2);
        %viscircles(centersStrong2, radiiStrong2,'EdgeColor','b');
        
        eye1 = centers(1,:);
        eye2 = centers(2,:);
        disp('Could find eyes using Hough :)')
    catch
        disp('Could NOT find eyes using Hough :(')
        eye1 = centroid1;
        eye2 = centroid2;
    end    
end