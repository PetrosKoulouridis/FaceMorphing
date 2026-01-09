function morphed_face = morph(face1, face2, points1, points2, tri, warp_frac, dissolve_frac)
%MORPH creates an intermidiate face between face1 and face2
%   face1, face2: images in uint8
%   points1, points2: correspondence of points between the two images,
%   respectively (must be of equal dimensions)
%   tri: connectivity list of a triangulation
%   warp_frac, dissolve_frac: parameters for feature warping and colour
%   dissolving between the images should be in [0, 1]
arguments
    face1, face2 uint8;
    points1, points2 (:, 2) double;
    tri (:,3);
    warp_frac, dissolve_frac (1,1) double;
end
if(~isequal(size(face1), size(face2)))
    error("Images must be of equal dimensions");
elseif(~isequal(size(points1), size(points2)))
    error("corresponding points must be same in nummber.")
end
morphed_face = zeros(size(face1), "uint8");

% form the features of morphed face according warp_frac
morphed_pts = (1 - warp_frac)*points1 + warp_frac*points2;

for i = 1:size(tri, 1)
    %create triangle matrices where collumns are points, for each of the
    %faces
    vertices = tri(i,:);
    triangle_pts1 = [points1(vertices, :)]';
    triangle_pts2 = [points2(vertices, :)]';
    morphed_triangle_pts = [morphed_pts(vertices, :)]';
    
    %compute affine transform from morphed triangle to the other two
    %(reverse warping)
    M1 = computeaffine(morphed_triangle_pts, triangle_pts1);
    M2 = computeaffine(morphed_triangle_pts, triangle_pts2);
    
    %create mask for the points given by the vertices of triangle
    ptsx = morphed_triangle_pts(1,:);
    ptsy = morphed_triangle_pts(2,:);
    mask = roipoly(morphed_face, ptsx, ptsy);

    %process image within the triangle's bounding box
    [yRange, xRange] = find(mask);
    xmin = min(xRange);
    xmax = max(xRange);
    ymin = min(yRange);
    ymax = max(yRange);

    [x, y] = meshgrid(xmin:xmax, ymin:ymax);
    points = [x(:), y(:)];
    
    % keep points inside the region of interest
    % use linear indeces to avoid looping through subscripts
    inside = mask(sub2ind(size(mask), points(:, 2), points(:, 1)));
    points = points(inside, :);

    %perform the wraps, keep the transponse (2*N matrix), list of points
    points1_transformed = applyaffine(M1, points');
    points1_transformed = points1_transformed';
    points2_transformed = applyaffine(M2, points');
    points2_transformed = points2_transformed';

    % Interpolate colors from both images
    colors1_r = interp2(double(face1(:,:,1)), points1_transformed(:,1), points1_transformed(:,2));
    colors1_g = interp2(double(face1(:,:,2)), points1_transformed(:,1), points1_transformed(:,2));
    colors1_b = interp2(double(face1(:,:,3)), points1_transformed(:,1), points1_transformed(:,2));
    
    colors2_r = interp2(double(face2(:,:,1)), points2_transformed(:,1), points2_transformed(:,2));
    colors2_g = interp2(double(face2(:,:,2)), points2_transformed(:,1), points2_transformed(:,2));
    colors2_b = interp2(double(face2(:,:,3)), points2_transformed(:,1), points2_transformed(:,2));

    colors_morphed_r = (1 - dissolve_frac)*colors1_r + dissolve_frac*colors2_r;
    colors_morphed_g = (1 - dissolve_frac)*colors1_g + dissolve_frac*colors2_g;
    colors_morphed_b = (1 - dissolve_frac)*colors1_b + dissolve_frac*colors2_b;

    [rows, cols] = size(morphed_face, [1 2]);
    % Assign colors to the average face directly, using pixels' indeces
    % the N*rows*cols term symbolizes the offset relative to the 3rd dimension (i.e.
    % colour channel)
    indices = sub2ind(size(mask), points(:,2), points(:,1));
    morphed_face(indices + 0*rows*cols) = uint8(colors_morphed_r);
    morphed_face(indices + 1*rows*cols) = uint8(colors_morphed_g);
    morphed_face(indices + 2*rows*cols) = uint8(colors_morphed_b);
end
end

