function pts_transformed = applyaffine(M, pts)
%APPLYAFFINE applies affine transformation M to points given. 
%   pts: set of N points, either (2,N) (2D
%   representation) or (3,N) (homogenous).
%
%   M: affine transformation, (3,3) matrix
%
%   NOTE: the dimensions/representation of the output points will be THE SAME
%   as the input triangle. i.e. when given homogenous coordinates, the
%   transformed points will be also be homogenous.   

arguments
    M (3,3) double;
    pts {mustBeNumeric};
end

%if non-homogenous coordinates were given, create them
if(size(pts, 1) == 2)
    newline = ones(1,size(pts, 2));
    pts = [pts ; newline];
    homogenous = false;
else
    homogenous = true;
end
pts_transformed = M*pts;

% if non homogenous coordinates were given, return points in that form
if ~homogenous
    pts_transformed = pts_transformed./pts_transformed(3,:);
    pts_transformed = pts_transformed(1:2, :);
end

end