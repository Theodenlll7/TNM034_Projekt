function number = number(im)
% Example image name
imageName = im;

% Define a regular expression pattern to match a digit after an underscore
pattern = '_\d+';

% Use the regexpi function to find matches in the image name
matches = regexpi(imageName, pattern, 'match');

% Extracted number as a string (remove the underscore)
extractedNumberStr = strrep(matches{1}, '_', '');

% Convert the extracted string to a numeric value if needed
extractedNumber = str2double(extractedNumberStr);

number = extractedNumber;
end