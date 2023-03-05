%FUNCTION: detectionEvaluation

%Function that calculates/returns the performance metrics: recall, precision 
%and F-measure of a given feature detection, considering a 5x5 square 
%neighborhood around each GT point ('recall', 'precision' and 'Fmeasure', 
%respectively). For this evaluation, the function receives as parameters a 
%0/1 matrix (with equivalent size to the image in analysis) filled with ones 
%at the correspondent positions of the detected feature points ('Points_matrix') 
%and a 2-column matrix with the Ground Truth points coordinates ('GT_points'-
%first column: GT points' lines; second column: GT points' columns).

function [recall, precision, Fmeasure] = detectionEvaluation(Points_matrix, GT_points)

[TP, FP, FN] = metrics2detection(Points_matrix, GT_points);

recall = TP/(TP + FN);
precision = TP/(TP + FP);
beta = 1;
Fmeasure = ((beta^2 + 1)*recall*precision) / (beta^2 * precision + recall);

end
