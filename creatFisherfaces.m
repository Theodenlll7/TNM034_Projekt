function creatFisherfaces()
    disp('Creating fisher model')
    % Load and preprocess face data, see function below
    [faceData, classIds, numImages] = prepData;
    
      % Extract unique class IDs and count occurrences
    uniqueIDs = unique(classIds);
    numClasses = numel(uniqueIDs);
    
    % Count occurrences for each class
    classCounts = zeros(1,numClasses);
    for i = 1:numClasses
        count = sum(classIds == uniqueIDs(i));
        classCounts(uniqueIDs(i)) = count;
    end
    
    % Flatten each image into a vector
    faceVectors = cellfun(@(x) x(:), faceData, 'UniformOutput', false);
    % Number of pixels in each image
    numPixels = numel(faceVectors{1}); 
    
    X = zeros(numPixels, numImages);
    for i = 1:numImages
        X(:, i) = faceVectors{i}';
    end

    meanFaceGlobal = mean(X, 2);
    
    %% PCA
    % Combine faceVectors to form X (each row represents an image)
    A = X - meanFaceGlobal;
    
    % Compute PCA
    V = A' * A;
    [U_pca, U_pcaEig] = eig(V, 'vector');
    [~, order] = sort(U_pcaEig, 'descend');
    U_pca = U_pca(:, order);
    U_pca = U_pca(:, 1:numImages - numClasses); % Select N-c most important eigenfaces
    
    % Project on PCA eigenfaces
    W_pca = A * U_pca;
    p_x = W_pca' * A;

    pMeanClassFace = zeros(size(p_x, 1), numClasses);
    for i = 1:numImages
        pMeanClassFace(:, classIds(i)) = pMeanClassFace(:, classIds(i)) + p_x(:,i);
    end

    pMeanClassFace = pMeanClassFace ./ classCounts;
    pMeanFace = mean(p_x, 2);

    %%
    
    %% Compute FLD

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
    
    [W_fld, eigenValues] = eig(S_b, S_w);
    [~, order] = sort(diag(eigenValues), 'descend');
    W_fld = W_fld(:, order);
    %W_fld = W_fld(:, 1:numImages - numClasses); % N-c Fisherfaces
    W_fld = W_fld(:, 1:numClasses-1); % N-c Fisherfaces
    
    %% Combine PCA and FLD to get the W_opt (Fisherfaces)
    % See refrence report
    W_opt = (W_fld' * W_pca')';
    W_opt = normalize(W_opt, 1, 'norm');

    % Project faces onto Fisherfaces
    W = W_opt' * X;
    % Save the trained Fisherface model
    save("trained_fisher_model", 'W', 'W_opt', 'classIds');
    disp("Succsesfully created fisher face model")

    % Reshape Fisherfaces back to image format
    imageSize = size(faceData{1}); % Set your image size accordingly
    montageImages(W_opt,imageSize);
end

function montageImages(inputImages, singleImageSize)
    numImages = size(inputImages, 2);
    processedImages = cell(1, numImages);

    for idx = 1:numImages
        reshapedImage = reshape(inputImages(:, idx), singleImageSize);
        scaledImage = rescale(reshapedImage, 0, 1);
        processedImages{idx} = double(scaledImage);
    end
    montage(processedImages);
end

function [faceData, classIds, numImages] = prepData()
    % Load face images from a folder
    imageDir = 'Faces/';
    imageDir2 = 'Faces/DB2/';
    testimages = dir(fullfile(imageDir, '*.jpg'));
    testimages2 = dir(fullfile(imageDir2, '*.jpg'));
    allImages = [testimages; testimages2];
    
    numImages = numel(allImages);
    
    faceData = cell(1, numImages);
    classIds = zeros(1, numImages);
    validImages = 0;  % Counter for valid images
    
    for i = 1:numImages
        % Check if the filename contains 'db0'
        if isempty(strfind(allImages(i).name, 'db0'))
            img = im2double(imread(fullfile(allImages(i).folder, allImages(i).name)));
            [eye1, eye2] = findEyes(img);
            faceData{validImages + 1} = faceNormalization(img, eye1, eye2);
            classIds(validImages + 1) = number(allImages(i).name);
            validImages = validImages + 1;
        end
    end
    
    faceData = faceData(1:validImages);
    classIds = classIds(1:validImages);
    numImages = validImages;
end