clc;
clear all;
close all;
%%%%%%%%%%%SWF%%%%%%%%%%%%
image = imread('cameraman.tif');
image0 = image;
figure;
imshow(image);

image = imnoise(image,'salt & pepper',0.08); % 加入椒盐噪声
figure;
imshow(image);

U0 = padarray(image(:, :, 1), [1 1], 'replicate');
% b=medfilt2(medfilt2(medfilt2(medfilt2(medfilt2(U0,[3,3])))));
b=medfilt2(medfilt2(medfilt2(U0,[3,3]),[3,3]),[3,3]);
figure;
imshow(b);
b0 =imcrop(b,[90,35,50,50]);
figure;
imshow(b0);
% u0 = ssim(b(2:257, 2:257), image0);
% v0 = psnr(b(2:257, 2:257), image0);

radius = 1;
type = 'median';
iteration = 2;

image = single(image);
result = image;
r = radius;            % filter radius
len = 2*r+1;           % filter length
chs = size(image, 3);  % channels
kernels0 = single(get_kernels0(r, type));

m = size(image, 1) + 2*r;
n = size(image, 2) + 2*r;
total = m * n;
[row, col] = ndgrid(1:m, 1:n); 
offset = row + m*(col-1) - total;


for ch = 1: chs
    U = padarray(image(:, :, ch), [r r], 'replicate');
    U0 = padarray(image(:, :, ch), [r r], 'replicate');
    for i = 1: iteration
        % count all projection distances
                for idx1 = 1: m-len+1
                    for idx2 = 1: n-len+1
                        roi = U(idx1:(idx1+len-1), idx2:(idx2+len-1) );  % valid area
%                         if(i == 1)
                        for k_idx = 1: 8
                            roi_new = roi .* kernels0(:, :, k_idx);
                            med(k_idx) = median(roi_new(:), 'omitnan');  % count the median value
                            d(k_idx) = med(k_idx) - U(idx1+r, idx2+r);
                        end
%                         else
%                             for k_idx = 1: 13
%                             roi_new = roi .* kernels0(:, :, k_idx);
%                             med(k_idx) = median(roi_new(:), 'omitnan');  % count the median value
%                             d(k_idx) = med(k_idx) - U(idx1+r, idx2+r);
%                             end
%                         end
                        tmp = abs(d);
                        [~, ind0] = min(tmp, [], 2);
                        U(idx1+r, idx2+r) = U(idx1+r, idx2+r) + d(ind0);
                    end
                end
    end
    result(:, :, ch) = U(r+1:end-r, r+1:end-r);
end

result = uint8(result);
figure;
imshow(result);
result0 =imcrop(result,[90,35,50,50]);
figure;
imshow(result0);
u = ssim(result, image0);
v = psnr(result, image0);