function adaptedImage = adjustRGB(imIn)
% Function for adjustment of color balance in RGB image using chromatic adaptation

% Turn image to double
imIn = im2double(imIn);

% Specify the illuminant color using illumwhite
illuminantColor = illumwhite(imIn, 1);

% Perform chromatic adaptation
adaptedImage = chromadapt(imIn, illuminantColor,'ColorSpace', 'prophoto-rgb');
end