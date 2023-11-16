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
    distances = arrayfun(@(i) norm(abs(W(:, i) - thisW(:, i))), 1:size(W, 1));
    [distance, closest_id] = min(distances);

    fprintf('\n=========================\nFrom getFaceId:\n\n');
    for i=1:length(distances)
        fprintf('Distance id %i: %.3e\n',i, distances(i));
    end
    fprintf('\nClosest id: %i',closest_id);
    fprintf('\n=========================\n');

    if(distance < threshhold), out_id = closest_id;
    else, out_id = 0;
    end
end

