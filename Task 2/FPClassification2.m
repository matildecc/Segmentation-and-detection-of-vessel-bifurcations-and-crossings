%FUNCTION: FPClassification2

%Function that returns the 0/1 matrixes correspondent to the distinction between
%bifurcations and crossings ('resultant_B_matrix' and 'resultant_C_matrix') by
%updating the matrixes 'B_matrix' and 'C_matrix', respectively, which
%correspond to the previously detected bifurcation and crossing points. For
%this purpose, each skeleton pixel ('row_pixel', 'col_pixel') is analysed
%using a circunference of radius 'radius'.

function [resultant_B_matrix, resultant_C_matrix] = FPClassification2(B_matrix, C_matrix, row_pixel, col_pixel, radius)
        
    dim_neighborhood = 2*radius - 1;
    %neighbor_matrix --> Matrix of ones, with a 0 on its center point 
    neighbor_matrix = ones(dim_neighborhood,dim_neighborhood); 
    center_point = round(dim_neighborhood/2);
    neighbor_matrix(center_point,center_point) = 0;

    %Column vector with the square neighborhood of dimension 'dim_neighborhood' 
    %of the pixel in analysis ('row_pixel', 'col_pixel'), in the matrix
    %'B_matrix'
    N = neighborhood (B_matrix,row_pixel, col_pixel,neighbor_matrix);
    num_elements = length(N);
    % Addition of a 0 to the center of vector 'N'
    N = [N(1:(num_elements/2)); 0;  N((num_elements/2 + 1):num_elements)];
    %Transformation of vector 'N' into a square matrix of dimension 
    %'dim_neighborhood'
    N = reshape(N,dim_neighborhood,dim_neighborhood);
    
    %Positions of the pixels, in the neighborhood of dimension 'dim_neighborhood' 
    %of the pixel in analysis ('row_pixel', 'col_pixel'), that are equal to 1
    if (sum(N(:)) >= 2)
           [L, C] = find(N == 1);

           real_coordinates = [row_pixel + (L - center_point), col_pixel + (C - center_point)]; 
          
            for i = 1 : length(real_coordinates)
            %Removes the pixels that are equal to 1 from  the 'B_matrix',
            %considering their correspondent positions
            B_matrix(real_coordinates(i,1), real_coordinates(i,2)) = 0;
            end
            C_matrix(round(mean(real_coordinates(:,1))),round(mean(real_coordinates(:,2)))) = 1;
    end

    resultant_B_matrix = B_matrix;
    resultant_C_matrix = C_matrix;
        
end
