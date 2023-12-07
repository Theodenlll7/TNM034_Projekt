function imOut = AWB(imIn, minAvgDiff)
    % Function for Automatic White Balance (AWB) correction
    
    imR = imIn(:,:,1);
    imG = imIn(:,:,2);
    imB = imIn(:,:,3);

    [m, n, ~] = size(imIn);

    avgR = 1 / (m * n) * sum(sum(imR)); 
    avgG = 1 / (m * n) * sum(sum(imG)); 
    avgB = 1 / (m * n) * sum(sum(imB));

    % Check if the color channels have significant differences in average values
    if abs(avgR - avgG) > minAvgDiff || abs(avgR - avgB) > minAvgDiff || abs(avgB - avgG) > minAvgDiff
        % Calculate scaling factors alpha and beta
        alpha = avgG / avgR;
        beta = avgG / avgB;

        % Apply scaling factors to the red and blue channels
        imOut(:,:,1) = alpha * imR;
        imOut(:,:,3) = beta * imB;
    else
        imOut = imIn;
    end
end
