function M = computeaffine(tri1_pts, tri2_pts)
%COMPUTEAFFINE computes the affine transformation needed to turn triangle1
%to triangle2. points should be given by the columns
%   tri1_pts, tri2_pts: matrix with the coordinates of points of the
%   source and target triangle, respectively.
arguments
    tri1_pts, tri2_pts {mustBeValidTriangle, mustBeNumeric};
end
if size(tri1_pts)==[2,3]
    tri1_pts = [tri1_pts(:,:);[1 1 1]];
end
if size(tri2_pts)==[2,3]
    tri2_pts = [tri2_pts(:,:);[1 1 1]];
end

%M*T1=T2 therefore M=T2*T1_inv, if it's invertible
if det(tri1_pts) ~= 0
    T1inv = inv(tri1_pts);
else
    %if it's not use pseudoinverse
    T1inv = pinv(tri2_pts);
end
M = tri2_pts*T1inv;
end
