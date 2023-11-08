function imWindow = eyesWindow(imIn)
imIn = im2double(imIn);

[n, m, ~] = size(imIn);

mask = zeros(n,m);
mask(round((n/2-n*0.18)):round((n/2+n*0.09)), round(m/2-n*0.25):round(m/2+n*0.25)) = 1;
imWindow = imIn.*mask;
end