function mustBeValidTriangle(T)
%MUSTBEVALIDTRIANGLE checks that triangle T is either 2D or homogenous
%coordinates
if(~isequal(size(T), [2,3]) && ~isequal(size(T), [3,3]))
    error(strcat("triangle points matrix dimensions should be 2x3 or 3x3 but are ",...
        int2str(size(T, 1)), "x", int2str(size(T, 2))));
end
end

