function creatFisherfaces()
    disp('Creating fisher model')
    % Load and preprocess face data, see function below
    [faceData, classIds, numImages] = prepData;
    
    % Extract unique class IDs and count occurrences
    uniqueIDs = unique(classIds);
    numClasses = numel(uniqueIDs);
    
    % Count occurrences for each class
    classCounts = containers.Map('KeyType', 'double', 'ValueType', 'double');
    for i = 1:numel(uniqueIDs)
        count = sum(classIds == uniqueIDs(i));
        classCounts(uniqueIDs(i)) = count;
    end
    
    % Flatten each image into a vector
    faceVectors = cellfun(@(x) x(:), faceData, 'UniformOutput', false);
    
    % Combine faceVectors to form X (each row represents an image)
    numPixels = numel(faceVectors{1}); % Number of pixels in each image
    
    % Calculate mean face for each class
    classmeanFaces = zeros(numPixels, numClasses);
    for i = 1:numImages
        classmeanFaces(:, classIds(i)) = classmeanFaces(:, classIds(i)) + faceVectors{i};
    end
    
    % Normalize by the count of occurrences for each class
    for i = 1:numClasses
        classmeanFaces(:, i) = classmeanFaces(:, i) / classCounts(i);
    end
    
    % Calculate global mean face
    meanFaceGlobal = mean(classmeanFaces, 2);
    
    % PCA
    % X all imsges where every colum is an image
    X = zeros(numPixels, numImages);
    for i = 1:numImages
        X(:, i) = faceVectors{i}';
    end
    
    A = X - meanFaceGlobal;
    
    % Compute PCA
    V = A' * A;
    [U_pca, U_pcaEig] = eig(V, 'vector');
    [~, order] = sort(U_pcaEig, 'descend');
    U_pca = U_pca(:, order);
    U_pca = U_pca(:, 1:numImages - numClasses); % Select N-c most important eigenfaces
    
    % Project on PCA eigenfaces
    W_pca = A * U_pca;
    X1 = X(:, order);
    p_x = W_pca' * X1;
    pMeanFace = W_pca' * meanFaceGlobal;
    
    % Project class mean faces on PCA eigenfaces
    for i = 1:numClasses
        pMeanClassFace(:, i) = W_pca' * classmeanFaces(:, i);
    end
    
    % Calculate Between-class Scatter Matrix (S_b)
    S_b = zeros(numImages - numClasses);
    for i = 1:numClasses
        difference = pMeanClassFace(:, i) - pMeanFace;
        S_b = S_b + classCounts(i) * (difference * difference');
    end
    
    % Calculate Within-class Scatter Matrix (S_w)
    S_w = zeros(numImages - numClasses);
    imagesByClasses = cell(numClasses, 1);
    for i = 1:numImages
        imagesByClasses{classIds(i)} = [imagesByClasses{classIds(i)}, p_x(:, i)];
    end
    for i = 1:numClasses
        for j = 1:size(imagesByClasses{i}, 2)
            difference = imagesByClasses{i}(:, j) - pMeanClassFace(:, i);
            S_w = S_w + (difference * difference');
        end
    end
    
    % Compute Fisherfaces (FLD)
    [W_fld, eigenValues] = eig(S_b, S_w);
    [~, order] = sort(diag(eigenValues), 'descend');
    W_fld = W_fld(:, order);
    W_fld = W_fld(:, 1:numImages - numClasses); % N-c Fisherfaces
    
    % Combine PCA and FLD to get the final set of Fisherfaces
    % See refrence report
    F = (W_fld' * W_pca')';
    F = normalize(F);
    
    % Project faces onto Fisherfaces
    W = F' * X;
    
    % Save the trained Fisherface model
    save("trained_fisher_model", 'meanFaceGlobal', 'W', 'F', 'classIds');
    disp("Succsesfully created fisher face model")
end


function [faceData, classIds, numImages] = prepData()
    % Load face images from a folder
    imageDir = 'Faces/';
    imageDir2 = 'Faces/DB2/';
    testimages = dir(fullfile(imageDir, '*.jpg'));
    testimages2 = dir(fullfile(imageDir2, '*.jpg'));
    allImages = [testimages; testimages2];
    
    numImages = numel(allImages);
    
    % Read images into a cell array
    faceData = cell(1, numImages);
    classIds = zeros(1, numImages);
    validImages = 0;  % Counter for valid images without 'db0' in the filename
    
    for i = 1:numImages
        % Check if the filename contains 'db0'
        if isempty(strfind(allImages(i).name, 'db0'))
            % Load your image
            img = im2double(imread(fullfile(allImages(i).folder, allImages(i).name)));
            [eye1, eye2] = findEyes(img);
            faceData{validImages + 1} = faceNormalization(img, eye1, eye2);
            classIds(validImages + 1) = number(allImages(i).name);
            validImages = validImages + 1;
        end
    end
    
    % Trim faceData and classIds to remove unused elements
    faceData = faceData(1:validImages);
    classIds = classIds(1:validImages);
    numImages = validImages;
end