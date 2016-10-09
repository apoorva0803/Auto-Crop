function [sx, sy, sWidth, sHeight] = auto_crop ( f )

%getting size of the input image


Ro = size(f,1);
Co = size(f,2);

filter = fspecial('Gaussian');
img_gray = rgb2gray(f);
img_gray = medfilt2(img_gray);
img_gray = imfilter(img_gray, filter, 'conv');

pdf  = imhist(img_gray);
normalized = pdf/numel(img_gray);
cdf = cumsum(normalized);

val = (min(cdf) + max(cdf))*0.5;
if  val <= 0.6
    val = 0.6; %max(0.65, min(cdf));
end
if  val >= 0.85
    val = max(0.85, min(cdf));
end

% threshold_img = img_gray;
threshold_index = find(cdf <= val, 1, 'last');
img_gray(img_gray(:) < threshold_index) = 0;

sobel_img = imgradient(img_gray, 'sobel');
sd_img = stdfilt(sobel_img, ones(9));
binary_img = sd_img > 50;
binary_img = medfilt2(binary_img);

bw = imfill(binary_img, 'holes');

r = Ro / 2;
c = Co / 2;

sx = r;
sy = c;
sWidth = randi([sx (sx+1+Ro/2)],1,1);
sHeight = randi([sy (sy+1+Co/2)],1,1); 

wsize = 11;
wrsize = 5;
window = zeros(wsize,1);
window_r = zeros(1, wrsize);

for y = r : -1 : 25  %col go up and look for y
    if bw (y-5:1:y+5,c) == window
        sy = y-wsize;
        break;
    end
end

for x = c : -1 : 25 %row go left from center and look for x
    if bw(r,x-2:1:x+2) == window_r
        sx = x+ wrsize;
        break;
    end
end

for y = r : 1 : Ro-25  %col go below and look for x
    if bw(y-5:1:y+5,c) == window
        sHeight = y - sy - wsize;
        break;
    end
end

for x = c : 1 : Co-25 % go right and look for x
    if bw(r, x-2:1:x+2) == window_r;
        sWidth = x - sx- wrsize;
        break;
    end
end