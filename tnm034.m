%%%%%%%%%%%%%%%%%%%%%%%%%%
function id = tnm034(im)
%
% im: Image of unknown face, RGB-image in uint8 format in the
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,…,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Your program code.
[eye1,eye2] = findEyes(im);

normalized_img = faceNormalization(im,eye1,eye2);
imshow(normalized_img)
id = getFaceId(normalized_img, 1000); % A normal dist between two difrent images is < 0.9*10^6

%%%%%%%%%%%%%%%%%%%%%%%%%%
end