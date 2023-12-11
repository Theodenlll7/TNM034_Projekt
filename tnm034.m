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
    threshold = 300;
    
    im = im2double(im);
    [eye1,eye2] = findEyes(im);    
    try
        normalized_img = faceNormalization(im,eye1,eye2);
        [closest_id, distance] = getFaceId(normalized_img, 18);
        if(distance < threshold); id = closest_id;
        else; id = 0;
        end
    catch
         id = -1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%
end