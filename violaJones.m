function mask = violaJones(maskIn, imIn)
    imIn = double(maskIn).*imIn;
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
        if m1 > m
            m1 = m;
        end
        if n2 < 1
            n2 = 1;
        end
        if m2 < 1
            m2 = 1;
        end    

        mask = zeros(n,m);
        mask(n1:n2, m1:m2) = 1;
    catch
        % If all hope fails...
        mask = maskIn;
    end
end