function stretchedImage = contrastStretchColor(inputImage, newMinValue, newMaxValue)
    % Get the dimensions of the input image
    [~, ~, numChannels] = size(inputImage);
    
    % Initialize the output image with the input image
    stretchedImage = inputImage;

    for channel = 1:numChannels
        % Extract the channel
        channelImage = inputImage(:, :, channel);
        
        % Calculate the minimum and maximum pixel values in the channel
        minValue = min(channelImage(:));
        maxValue = max(channelImage(:));

        % Cast minValue and maxValue to double for consistent data type
        minValue = double(minValue);
        maxValue = double(maxValue);

        % Perform contrast stretching on the channel
        stretchedImage(:, :, channel) = (double(channelImage) - minValue) / (maxValue - minValue) * (newMaxValue - newMinValue) + newMinValue;
    end
end