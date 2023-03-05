%FUNCTION: FPClassification1

%Function that returns the updated coordinates of feature points classified as
%bifurcations or crossings ('B_coordinates' and 'C_coordinates', respectively), 
%considering an analysis of the image's skeleton ('skeleton_matrix') with
%circumferences of radius 'R1', 'R2' and 'R3' around the pixel ('line_pixel', 'col_pixel')

%Note: 'B_coordinates' and 'C_coordinates' are matrixes with two columns, 
%where the first one corresponds to the pixel lines and the second one
%to their respective columns

function [B_coordinates,C_coordinates] = FPClassification1 (skeleton_matrix, line_pixel, col_pixel, R1, R2, R3, B_coordinates, C_coordinates)
     
     %Analysis of the intersections between the skeleton vessels and circumferences
     %with different radius ('R1', 'R2' and 'R3'), for a given pixel 
     %('line_pixel', 'col_pixel')
     [B1, C1] = vesselIntersections(skeleton_matrix,line_pixel,col_pixel,R1);
     [B2, C2] = vesselIntersections(skeleton_matrix,line_pixel,col_pixel,R2);
     [B3, C3] = vesselIntersections(skeleton_matrix,line_pixel,col_pixel,R3);
     
     %Feature points' classification, based on to the following formulas:
     Bifurcations = B1 + B2 + 2*B3;
     Crossings = 2*C1 + C2 + C3;
     
     %Saves the coordinates of the pixel in analysis ('line_pixel', 'col_pixel')
     %as a bifurcation or crossing point (in separated matrixes)
     if (Bifurcations >= Crossings)
         B_coordinates = [B_coordinates; [line_pixel, col_pixel]];
     else
         C_coordinates = [C_coordinates; [line_pixel, col_pixel]];
     end
     
end
