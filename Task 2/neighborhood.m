%FUNCTION: neighborhood

%Function that returns a vector 'N' correspondent to the neighborhood in the
%'analysis_matrix' of a pixel with coordinates ('row_pixel', 'col_pixel'), 
%with a shape defined by the 0/1 matrix 'neighborhood_matrix'.

%Example:

%     1 2 3 4 5 6 7 8 9 
%     9 8 7 6 5 4 3 2 1
%     1 2 3 4 5 6 7 8 9 
% A = 9 8 7 6 5 4 3 2 1
%     1 2 3 4 5 6 7 8 9 
%     9 8 7 6 5 4 3 2 1
%     1 2 3 4 5 6 7 8 9 

%      1 1 1 1 1
%      1 1 1 1 1
% n =  1 1 0 1 1
%      1 1 1 1 1
%      1 1 1 1 1

%N1 = neighborhood (A, 4, 6, n) 
%   = [6;4;6;4;6;5;5;5;5;5;4;6;6;4;3;7;3;7;3;2;8;2;8;2]

function N = neighborhood (analysis_matrix, row_pixel, col_pixel, neighborhood_matrix)
        
[rows, cols] = size(analysis_matrix);

%'matrix_aux' --> auxiliar matrix with equivalent size to the 'analysis_matrix'
matrix_aux = zeros(rows, cols);

%Attributes the value 1 to the pixel in analysis ('row_pixel', 'col_pixel')
%in the matrix 'matrix_aux'
matrix_aux(row_pixel, col_pixel) = 1;

%Vector with the 8-neighborhood of the pixel in analysis ('row_pixel', 'col_pixel')
N = analysis_matrix((conv2(matrix_aux,neighborhood_matrix,'same')>0));    

end



