%FUNCTION: metrics2detection

%Function that calculates/returns the metrics: true positives, false
%positives and false negatives of a given feature detection, considering a 
%5x5 square neighborhood around each GT point('TP', 'FP' and 'FN',respectively). 
%For this evaluation, the function receives as parameters a 0/1 matrix 
%(with equivalent size to the image in analysis)filled with ones at the 
%correspondent positions of the detected feature points ('Points_matrix') 
%and a 2-column matrix with the Ground Truth points coordinates ('GT_points'-
%first column: GT points' lines; second column: GT points' columns).

function [TP, FP, FN] = metrics2detection(Points_matrix, GT_points)

[lines, cols] = size(Points_matrix);

%'GT matrix' --> 0/1 matrix (with equivalent size to 'Points_matrix')
%filled with ones at the correspondent positions of the GT points and their 
%5x5 neighborhood 
GT_matrix = zeros(lines, cols);
for j = 1 : length(GT_points)
    
   line_GT = GT_points(j,1);
   col_GT = GT_points(j,2);
   GT_matrix((line_GT - 2) : (line_GT + 2),(col_GT - 2) : (col_GT + 2)) = ones(5,5);
   
end

TP = sum(sum((Points_matrix + GT_matrix) == 2));

% sum(Points_matrix(:)) --> Total number of detected feature points
FP = sum(Points_matrix(:)) - TP;

% length(GT_points) --> Total number of ground truth points
FN = length(GT_points) - TP;

end