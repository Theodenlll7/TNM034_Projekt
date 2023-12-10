function [out_id, distance] = getFaceId(image, threshhold)
    load("trained_fisher_model.mat", 'W', 'W_opt', 'classIds');

    face = image(:);
    %pixels = numel(meanFaceGlobal)
    %face = double(x(1:pixels)) - meanFaceGlobal;
    
    thisW = W_opt' * face;
    
    % Calculate Square Euclidean distances
    distances = sum((W - thisW).^2, 1);

    [distance, closestEigenface] = min(distances);

    fprintf('\n\n=========================\nFrom getFaceId:\n\n');
    % for i=1:length(distances)
    %     fprintf('Distance id %i: %.3e\n',i, distances(i));
    % end
    %fprintf('\nClosest id: %i; distance: %.8f', classIds(closestEigenface), distance);

    out_id = classIds(closestEigenface);
end
