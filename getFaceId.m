function [out_id] = getFaceId(image, threshhold)
    load("traind_fisher_model.mat", 'mean_face', 'W', 'U');
    load('matlab.mat', 'correctIds')

    x = image(:);
    x = x(:);
    face = double(x) - mean_face;
    
    thisW = U' * face;
    
    % Calculate distances between W and face vectors
    distances = arrayfun(@(i) norm(abs(W(:, i) - thisW)), 1:size(W, 2));
    [distance, closest_id] = min(distances);

    fprintf('\n=========================\nFrom getFaceId:\n\n');
    for i=1:length(distances)
        fprintf('Distance id %i: %.3e\n',i, distances(i));
    end
    fprintf('\nClosest id: %i; %i', correctIds(closest_id));
    fprintf('\n=========================\n');

    if(distance < threshhold), out_id = correctIds(closest_id);
    else, out_id = 0;
    end
end

