function im = drawX(im, n, m)
    im = im2double(im);
    m = round(m);
    n = round(n);
    % Horizontal line
    im(m-3:m+3, round(n - 15):round(n + 15)) = 1;
    % Vertical line
    im(round(m - 15):round(m + 15), n-3:n+3) = 1;
end