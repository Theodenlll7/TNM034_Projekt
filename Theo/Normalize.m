function normalized = Normalize(img)

    % Crop image
    cropped = faceCrop(img, mask);

    % Warp faces to match each other
    pts = [le, 1;
           re, 1;
           m, 1];
    aligned = alignFace(cropped, pts);

    aligned = rgb2gray(aligned);
    normalized = histeq(aligned);
end