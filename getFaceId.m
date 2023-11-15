function [out_id] = getFaceId(image, threshhold)
    load("traind_model.mat", 'mean_face', 'W', 'U');
    
    image = rgb2gray(image);
    x = image(:);
    [~, columns] = size(mean_face);
    x = repmat(x, 1, columns);
    face = double(x) - mean_face;
    
    thisW = U'*face;

    % Transpose face to perform calculations column-wise
    face = face';
    
    % Calculate distances between W and face vectors
    distances = arrayfun(@(i) norm(abs(W(:, i) - thisW(i, :))), 1:size(W, 1));
    [distance, id] = min(distances);
    if(distance < threshhold), out_id = id;
    else, out_id = 0;
    end
end
