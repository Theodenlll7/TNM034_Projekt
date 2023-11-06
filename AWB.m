function im = AWB(im)
imR = imIn(:,:,1);
imG = imIn(:,:,2);
imB = imIn(:,:,3);

[m,n,c] = size(imIn);
R_avg = 1/(m*n)*sum(sum(imR)); 
G_avg = 1/(m*n)*sum(sum(imG)); 
B_avg = 1/(m*n)*sum(sum(imB)); 

end