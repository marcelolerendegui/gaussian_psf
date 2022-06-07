function img = gen_gaussian(img_coords, gauss_scats)
%GEN_GAUSSIAN Gaussian scatterer image generation.
%   IMG = GEN_GAUSSIAN(IMG_COORDS, GAUSS_SCATS) 
%   GAUSS_SCATS is a N-by-6 matrix with the following row structure
%       [A, x0, z0, sgm_x, sgm_z, theta]
       
    X = img_coords(:,1);
    Z = img_coords(:,3);
    
    img = zeros(size(X));
    
    ng = size(gauss_scats, 1);
    
    for gi = 1:ng
        A     = gauss_scats(gi, 1);
        x0    = gauss_scats(gi, 2);
        z0    = gauss_scats(gi, 3);
        sgm_x = gauss_scats(gi, 4);
        sgm_z = gauss_scats(gi, 5);
        theta = gauss_scats(gi, 6);

        a = cosd(theta)^2 / (2 * sgm_x^2) + sind(theta)^2 / (2 * sgm_z^2);
        b = -sind(2 * theta) / (4 * sgm_x^2) + sind(2 * theta) / (4 * sgm_z^2);
        c = sind(theta)^2 / (2 * sgm_x^2) + cosd(theta)^2 / (2 * sgm_z^2);

        img = img + A * exp(-(a * (X - x0).^2 + 2 * b * (X - x0) .* (Z - z0) + c * (Z - z0).^2));
    end
end