#!/usr/bin/octave

% INFO: Script to perform image processing operations
% Usage: ./question_2.sh

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part (a)

% Load image
img1 = imread('Lena.png');
img1 = double(img1);

% Sobel Operator
sobel_x = [-1, 0, 1; 
           -2, 0, 2; 
           -1, 0, 1];
sobel_y = [-1, -2, -1; 
            0,  0,  0; 
            1,  2,  1];

% Apply Sobel Operator to image

Gx = conv2(img1, sobel_x, 'same');
Gy = conv2(img1, sobel_y, 'same');
sobel_result = sqrt(Gx.^2 + Gy.^2);
sobel_img = sobel_result / max(sobel_result(:));

% Apply brightness filter to image

% Brighten the image
k_bright = [0, 0, 0; 
            0, 1.5, 0; 
            0, 0, 0];
bright_img = conv2(img1, k_bright, 'same');
bright_img = uint8(bright_img);

% Dim the image

k_dim = [0, 0, 0; 
         0, 0.25, 0; 
         0, 0, 0];
dim_img = conv2(img1, k_dim, 'same');
dim_img = uint8(dim_img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part(b)

% Apply blur filter to noisy image to smoothen it

img2 = imread('Noisy_Lena.png');
img2 = double(img2);

% Gaussian Blur

k_gaussian_blur = [0.0625, 0.125, 0.0625; 
                   0.125, 0.25, 0.125; 
                   0.0625, 0.125, 0.0625];

% Apply Gaussian Blur to image

blur_img = conv2(img2, k_gaussian_blur, 'same');
blur_img = uint8(blur_img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part(c)

% Doing Fast Fourier Transform (FFT) 
F = fft2(img2);

% Create a meshgrid

[M, N] = size(img2);
[u, v] = meshgrid(1:N, 1:M);

% Cutoff frequency

D0 = 90;

% Create a filter

H = exp(-((u - N/2).^2 + (v - M/2).^2) / (2 * D0^2));
F_filtered = F .* fftshift(H);

% Inverse FFT

img_filtered = ifft2(F_filtered);
img_filtered = real(img_filtered);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create the output directory

mkdir('me23b012_output_images');

% Save the images to the output directory

imwrite(uint8(img1), 'me23b012_output_images/original_image.png');
imwrite(sobel_img, 'me23b012_output_images/edge_detection.png');
imwrite(bright_img, 'me23b012_output_images/brighter.png');
imwrite(dim_img, 'me23b012_output_images/dimmer.png');
imwrite(uint8(img2), 'me23b012_output_images/noisy_image.png');
imwrite(blur_img, 'me23b012_output_images/blur_noise_reduction.png');
imwrite(uint8(img_filtered), 'me23b012_output_images/fft_noise_reduction.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%