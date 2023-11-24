function mask = violaJones(imIn)
    faceDetector = vision.CascadeObjectDetector('EyePairBig');
    bbox = faceDetector(imIn);
    n1 = bbox(1);           % x
    n2 = bbox(1)+bbox(3);   % x + w
    m1 = bbox(2);           % y
    m2 = bbox(2)+bbox(4);   % y + h
    
    [n,m,~] = size(imIn);
    mask = zeros(n,m);
    mask(m1:m2, n1:n2) = 1;
end