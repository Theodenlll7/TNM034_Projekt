function [out_id] = getFaceId(image, threshhold)
    load("trained_fisher_model.mat", 'meanFaceGlobal', 'W', 'F', 'classIds');

    x = image(:);
    pixels = numel(meanFaceGlobal)
    face = double(x(1:pixels)) - meanFaceGlobal;
    
    thisW = F' * face;
    
    % Calculate distances between W and face vectors
    distances = arrayfun(@(i) norm(abs(W(:, i) - thisW)), 1:size(W, 2));

    [distance, closesEigenface] = min(distances);

     % fprintf('\n\n=========================\nFrom getFaceId:\n\n');
     % for i=1:length(distances)
     %     fprintf('Distance id %i: %.3e\n',i, distances(i));
     % end
     % fprintf('\nmin dist: %.3f', min(distances));
     % fprintf('\nClosest id: %i; %i', classIds(closesEigenface));

    if(distance < threshhold), out_id = classIds(closesEigenface);
    else, out_id = 0;
    end
end

