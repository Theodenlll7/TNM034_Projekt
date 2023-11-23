function mask = keepNLargestObjects(binaryImage, n)
    labeledImage = bwlabel(binaryImage);
    stats = regionprops(labeledImage, 'Area');

    if ~isempty(stats)
        areas = [stats.Area];
        [~, idx] = sort(areas, 'descend');
        
        % Keep at most 'n' objects or fewer if there are less than 'n'
        numObjects = min(n, numel(idx));
        
        mask = ismember(labeledImage, idx(1:numObjects));
    else
        mask = ones(size(binaryImage));
        disp('No objects found in the binary image.');
    end
end