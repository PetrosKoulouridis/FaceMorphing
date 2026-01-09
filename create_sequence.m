clear;
clc;
face1 = imread('images\face1.jpg');
face2 = imread('images\face2.jpg');

%load the corresponding points
points1 = load("points\points1.mat");
points1 = points1.points1;
points2 = load("points\points2.mat");
points2 = points2.points2;

%create triangulation based on the average points, to reduce deformed
%triangles
avg_points = (points1+points2)/2;
tri = delaunay(avg_points);

%create a struct of frames for movie
outputVideo = VideoWriter('images\morphing_video.avi');
outputVideo.FrameRate = 30;
open(outputVideo);

%44 intervals between 45 frames
p = 0;
parameter_step = 1/44; 

for f=1:45
    cur_frame = morph(face1, face2, points1, points2, tri, p, p);
    if(round(p*100) == 25)
        imwrite(cur_frame, "images\quarter_face.jpg");
    elseif(round(p*100) == 50)
        imwrite(cur_frame, "images\half_face.jpg");
    elseif(round(p*100) == 75)
        imwrite(cur_frame, "images\three_quarters_face.jpg");
    end
    %store frame in video file
    writeVideo(outputVideo, cur_frame);
    p = p + parameter_step;
    if(p > 1)
        p = 1;
    end
end
close(outputVideo);
