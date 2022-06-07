%% Cleanup
clear all;
close all;
clc;

%% Setup
F0 = 7.24e6;

lambda = GlobalConfig().c / F0;
px_size = [lambda * 0.4, 0, lambda * 0.4];

img_count   = [256, 1, 256];
img_center  = [ 0e-3, 0e-3, 27.5e-3];
img_size    = img_count .* px_size;

corr_mat = [ ...    A  ux  uz  sx  sz  th
                    1,  0,  0,  0,  0,  0 ; ...
                    0,  1,  0,  0,  0,  0 ; ...
                    0,  0,  1,  0,  0,  0 ; ...
                    0,  0,  0,  1,  0.25,  0 ; ...
                    0,  0,  0,  0.25,  1,  0 ; ...
                    0,  0,  0,  0,  0,  1 ; ...
];

A_range = [5, 10];
sx_range = [100e-6, 250e-6];
sz_range = [100e-6, 250e-6];
th_range = [0, 60];

gt_img_count = [1024, 1, 1024];

%% Create image coordinates
[X, Y, Z] = ndgrid( ...
            linspace(-1, 1, img_count(1)), ...
            linspace(-1, 1, img_count(2)), ...
            linspace(-1, 1, img_count(3)) ...
);
img_coords = [X(:) Y(:) Z(:)] .* (img_size/2) + img_center;

%% Generate image
nbubs = 100;

% random parameters
gauss_params = rand(nbubs, 6);

% Add correlation
gauss_params = gauss_params * chol(corr_mat)';

% make it so sx>=sz (avoid th+90)
gauss_params(:,3:4) = sort(gauss_params(:,3:4), 2);

% scale
gauss_params = gauss_params - 0.5;
gauss_params = gauss_params .* ...
    [diff(A_range), img_size(1), img_size(3), diff(sx_range), diff(sz_range), diff(th_range)];

gauss_params = gauss_params + ...
    [mean(A_range), img_center(1), img_center(3), mean(sx_range), mean(sz_range), mean(th_range)];

A  = gauss_params(:, 1);
ux = gauss_params(:, 2);
uz = gauss_params(:, 3);
sx = gauss_params(:, 4);
sz = gauss_params(:, 5);
th = gauss_params(:, 6);

% generate image
img = gen_gaussian(img_coords, gauss_params);
img = reshape(img, img_count(1), img_count(3))';
img = rescale(img);

%% Add Noise
% Investigate what noise is better for simulating ultrasound noise?

img = img + 0.075 * randn(size(img));
img = imnoise(img, 'speckle', 0.01);

%% Plot
img = rescale(img);
xlims = img_center(1) + [-img_size(1), img_size(1)]/2;
zlims = img_center(3) + [-img_size(3), img_size(3)]/2;

figure; imagesc(xlims, zlims, img);
hold on
plot(ux, uz,'r*');
axis image;

%% Generate Output
outimg = zeros(gt_img_count);
% point coordinates
pos = [ux, ux*0, uz];
% transform to out_img pixel positions
pos = pos - (img_center - img_size/2);
pos = pos ./ img_size;
pos(:,2) = 1;
pos = pos .* (gt_img_count - 1) + 1;

% nearest neighbour interp
pos = round(pos);

outimg(sub2ind(gt_img_count, pos(:,1), pos(:,2), pos(:,3))) = 1;
outimg = squeeze(outimg);

figure();
imagesc(outimg');
axis image;