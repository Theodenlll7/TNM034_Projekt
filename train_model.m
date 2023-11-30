% Load face images from a folder
try
    imageDir = 'Faces/';
    testimages = dir(fullfile(imageDir, 'db1*.jpg'));
    numImages = numel(testimages);
catch
    disp("Wrong file path for train_model")
end    
% Read images into a cell array
faceData = cell(1, numImages);
for i = 1:numImages
    % Load your image
    img = imread(fullfile(imageDir, "db1_" + i + ".jpg"));
    [eye1, eye2] = findEyes(img);
    faceData{i} = faceNormalization(img, eye1, eye2);
end

% Convert images to grayscale
faceDataGray = cellfun(@(x) rgb2gray(x), faceData, 'UniformOutput', false);

% Flatten each image into a vector
faceVectors = cellfun(@(x) x(:), faceDataGray, 'UniformOutput', false);
% Combine faceVectors to form X (each row represents an image)
numPixels = numel(faceVectors{1}); % Number of pixels in each image

X = zeros(numPixels, numImages);

for i = 1:numImages
    X(:, i) = faceVectors{i}';
end


mean_face = mean(X, 2)

A = X - mean_face;

V = A'*A;

E = eig(V);

U = A*V;


%[width, ~] = size(faceData{1});
%figure;
%for i = 1:16
%    eigenface = reshape(u(:,i), width, []);
%    subplot(4, 4, i);
%    imshow(eigenface, []);
%    title(['Eigenface ', num2str(i)]);
%end

W = U'*A;

save("traind_model", 'mean_face', 'W', 'U');
disp("Succsesfully traind face recognision model")