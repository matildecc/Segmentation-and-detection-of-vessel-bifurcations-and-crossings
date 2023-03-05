%% Main algorithm - Feature Detection
% Authors: Inês Campos and Maria Carolina Brás

clear; clc;
close all;

recall_vec = [];
precision_vec = [];
Fmeasure_vec = [];
time = [];

for itr = 1:20

% -------------------------------------------------------------------
% FIRST STEP - READING THE IMAGES AND EXCEL FILES
% -------------------------------------------------------------------    

tic; 
%num = 1; % To read the Training set of files
num = 2; %To read the Test set of files
[img_filename, xls_filename] = fileNames(itr, num);

% -------------------------------------------------------------------
% SECOND STEP - SKELETONIZATION USING 2 SPURS
% -------------------------------------------------------------------

% Original Image
Img = imread(img_filename); Img = im2double(Img);

% Skeleton by thinning
Skeleton = bwmorph(Img, 'skel',Inf);

% Removes unwanted small branches of the skeleton (spurs)
Skeleton = bwmorph(Skeleton,'spur',2);  

% Size of the image in analysis
[lines_Img, cols_Img] = size(Img);

% -------------------------------------------------------------------------
% THIRD STEP - CALCULATION OF THE INTERSECTION NUMBER FOR EACH PIXEL BY
% GOING THROUGH THE ZERO PADDED SKELETON, USING THE FORMULA OF THE ARTICLE
% -------------------------------------------------------------------------

Skeleton_ZP = zeroPadding(Skeleton);

% I_matrix is a matrix where the vessel end points, internal points and
% bifurcations/crossovers have a value different from 0
I_matrix = intersectionNum(Skeleton_ZP);

% ----------------------------------------------------------------------------
% FOURTH STEP 
% - CLASSIFICATION OF FEATURE POINTS BASED ON THE INTERSECTION NUMBER
% - REMOVAL OF THE WRONGLY IDENTIFIED POINTS 
%
% A certain pixel (L,C) is considered a:
%         - Vessel end point if I_matrix(L,C) = 1
%         - Vessel internal point if I_matrix(L,C) = 2
%         - Vessel bifurcation or crossover if I_matrix(L,C) > 2
%
% ----------------------------------------------------------------------------

% Saves the coordinates of the bifurcations and crossings detected
[line_all_FP,col_all_FP] = find(I_matrix > 2);

% Removes the wrongly identified feature points on black pixels
% Points_matrix is a matrix with 0s and 1s, with the same size as the original 
% image, where the feature points have the value 1
Points_matrix = zeros(lines_Img, cols_Img);
for j = 1 : length(line_all_FP)
    if (Img(line_all_FP(j),col_all_FP(j)) ~= 0)
        Points_matrix(line_all_FP(j),col_all_FP(j)) = 1;
    end
end

% ----------------------------------------------------------------------------
% FIFTH STEP:
% - REMOVAL OF THE CONSECUTIVE POINTS (FEATURE POINTS THAT HAVE 
% FEATURE POINTS IN A 5X5 NEIGHBORHOOD 
% The wrongly identified consecutive feature points are removed by analizing a
% 5x5 neighborhood around each one of them. If a certain detected feature
% point has other feature points in a 5x5 neighborhood, these will be
% eliminated from the feature points matrix, Points_matrix
% ----------------------------------------------------------------------------

for k = 1 : length(line_all_FP)
    
     % Checks if the pixel in analysis still has the value 1, as some
     % pixels are turning into 0 because they are no longer considered
     % feature points
     if (Points_matrix(line_all_FP(k), col_all_FP(k)) == 1)
        
        Points_matrix = removeConsecutiveFP(Points_matrix,line_all_FP(k), col_all_FP(k), 5);
                
     end
end

[line_FP,col_FP] = find(Points_matrix == 1);

% -------------------------------------------------------------------
% SIXTH STEP - FEATURE POINTS CLASSIFICATION (Local analysis)
% 3 circles with different radius, centered in each detected feature point
% will be analyzed. The weighted sum of the number of intersections between 
% each circle and the Skeleton will determine whether the point is a 
% bifurcation or a crossing.
% The circle will be approximated by a square neighborhood.
% -------------------------------------------------------------------

rho = 2;
R2 = 4; % ---> Corresponds to a 7x7 square matrix
R1 = R2 - rho; % ---> Corresponds to a 3x3 square matrix
R3 = R2 + rho; % ---> Corresponds to a 11x11 square matrix

% Classifies the previously detected feature points in bifurcations or
% crossings, according to the formula present in the article and saves the
% corresponding coordinates
B_coordinates = [];
C_coordinates = [];
for p = 1: length(line_FP)
    [B_coordinates,C_coordinates] = FPClassification1 (Skeleton, line_FP(p), col_FP(p), R1, R2, R3, B_coordinates, C_coordinates);    
end

% -------------------------------------------------------------------
% SEVENTH STEP - FEATURE POINT CLASSIFICATION (Topological analysis)
% Checks if the 2 bifurcations are, in fact, 1 crossover point.
% Two bifurcation points become a crossover when the distance between them
% is less than 2*R2
% A circle with radius = R2 will go through the skeleton, which means a 5x5
% neighborhood around each pixel will be analyzed
% If, inside it, lay 2 bifurcation points, the mean coordinates between the
% 2 points are calculated and saved as a crossover point.
% These bifurcation points' coordinates are deleted.
% -------------------------------------------------------------------

% Create a matrix with the same size of the image and 1s in the points that
% are considered bifurcations

B_matrix = zeros(lines_Img, cols_Img);
for z = 1 : length(B_coordinates(:,1))
    B_matrix(B_coordinates(z,1), B_coordinates(z,2)) = 1;
end

C_matrix = zeros(lines_Img, cols_Img);
for w = 1 : length(C_coordinates(:,1))
    C_matrix(C_coordinates(w,1), C_coordinates(w,2)) = 1;
end


for l_skeleton = 1:lines_Img
    for c_skeleton = 1:cols_Img
        
        if (Skeleton(l_skeleton,c_skeleton) == 1)
            % Ckecks if the pixel in analysis has, inside a 7x7 neighborhood, two 
            % bifurcation points. If so, they will no longer vbe regarded
            % as feature points and the mean between their coordinates will
            % be saved as a crossing
            [B_matrix, C_matrix] = FPClassification2(B_matrix, C_matrix, l_skeleton, c_skeleton, 4);
        end
    end
        
end

[lines_new_B_coord, cols_new_B_coord] = find(B_matrix == 1);
[lines_new_C_coord, cols_new_C_coord] = find(C_matrix == 1);
 
% ----------------------------------------------------------------------
% EIGHTH STEP - METRICS CALCULATION
% ----------------------------------------------------------------------
GT_points = xlsread(xls_filename);

% To get the metrics without the distinction between crossings and bifurcations
[TP, FP, FN] = metrics2detection(Points_matrix, GT_points);
[recall, precision, Fmeasure] = detectionEvaluation(Points_matrix, GT_points);

% To get the metrics for the distinction step
% Points_matrix_new = B_matrix + C_matrix;
% [TP, FP, FN] = metrics2detection(Points_matrix_new, GT_points);
% [recall, precision, Fmeasure] = detectionEvaluation(Points_matrix_new, GT_points);

recall_vec = [recall_vec, recall];
precision_vec = [precision_vec, precision];
Fmeasure_vec = [Fmeasure_vec, Fmeasure];

time_itr = toc;
time = [time, time_itr];

end

recall_mean = mean(recall_vec);
precision_mean = mean(precision_vec);
Fmeasure_mean = mean(Fmeasure_vec);

recall_std = std(recall_vec);
precision_std = std(precision_vec);
Fmeasure_std = std(Fmeasure_vec);
    
time_mean = mean(time);
time_std = std(time);   

