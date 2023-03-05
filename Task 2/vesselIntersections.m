%FUNCTION: vesselIntersections

%Function that calculates the number of intersections between the white 
%pixels of a given image ('analysis_matrix') and a circumference with center
%('row_center','col_center') and radius 'radius'. If the number of
%intersections equals 3, the center of the circunference will be identified
%as a bifurcation, thus B=1. If the number of intersections equals 4, the center of
%the circumference will be identified as a crossing, thus C=1. According to 
%this feature points' identification, the function returns the correspondent
%binary values for 'B' and 'C'.

function [B, C] = vesselIntersections(analysis_matrix,row_center,col_center,radius)
    
    %Note: a circumference with radius 'radius' will be aproximated by the
    %1-pixel-with border of a square matrix with 2*radius-1 dimension
    circunf_matrix = bmGenerator(2*radius-1);
    intersected_pixels = neighborhood (analysis_matrix,row_center,col_center,circunf_matrix);
    num_intersections = sum(intersected_pixels);
   
    if (num_intersections == 3)
        B = 1;
        C = 0;
    elseif (num_intersections == 4)
        B = 0;
        C = 1;
    else
        B = 0;
        C = 0;
    end
    
end