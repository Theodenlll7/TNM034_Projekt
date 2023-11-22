function [imOut] = showEyes(imIn,eye1, eye2)
    imIn = drawX(imIn,eye1(1),eye1(2));
    imOut = drawX(imIn,eye2(1),eye2(2));
end