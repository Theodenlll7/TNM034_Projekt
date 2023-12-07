function stretchedImage = contrastStretchColor(inputImage, newMinValue, newMaxValue)
    [~, ~, numChannels] = size(inputImage);
    
    stretchedImage = inputImage;

    for channel = 1:numChannels
        channelImage = inputImage(:, :, channel);
        
        minValue = min(channelImage(:));
        maxValue = max(channelImage(:));

        minValue = double(minValue);
        maxValue = double(maxValue);

        % Perform contrast stretching on the channel
        stretchedImage(:, :, channel) = (double(channelImage) - minValue) / (maxValue - minValue) * (newMaxValue - newMinValue) + newMinValue;

        
    end
end