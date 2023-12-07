function mask = violaJones(maskIn, imIn)
    imIn = double(maskIn).*imIn;
    imIn = contrastStretchColor(AWB(colorCorrection(imIn),0.5),0,1);
    try
        faceDetector = vision.CascadeObjectDetector('EyePairBig');
        bbox = faceDetector(imIn);
        m1 = bbox(1);           % x
        m2 = bbox(1)+bbox(3);   % x + w
        n1 = bbox(2);           % y
        n2 = bbox(2)+bbox(4);   % y + h
    
        [n,m,~] = size(imIn);
        if n2 > n 
            n2 = n;
        end    
        if m2 > m
            m2 = m;
        end
        if n1 > n
            n1 = n;
        end
        if m1 > m
            m1 = m;
        end    

        mask = zeros(n,m);
        mask(n1:n2, m1:m2) = 1;
        size(mask);
        SE = strel('disk', 8);
        mask = imdilate(mask, SE);

    catch
        % If all hope fails...
        mask = maskIn;
    end
end