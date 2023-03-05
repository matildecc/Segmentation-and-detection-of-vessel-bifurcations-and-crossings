%FUNCTION: removeConsecutiveFP

%Function that returns a matrix ('resultant_matrix') correspondent to the
%removal of the white pixels present at the neighborhood of dimension
%'dim_neighborhood' of a given pixel ('row_pixel', 'col_pixel') from the
%matrix 'analysis_matrix'.
%Note: 'dim_neighborhood' must be an odd value

function resultant_matrix = removeConsecutiveFP(analysis_matrix,row_pixel, col_pixel, dim_neighborhood)

    %neighbor_matrix --> Matrix of ones, with a 0 on its center point 
    neighbor_matrix = ones(dim_neighborhood); 
    center_point = round(dim_neighborhood/2);
    neighbor_matrix(center_point,center_point) = 0;
    
    %Column vector with the square neighborhood of dimension 'dim_neighborhood' 
    %of the pixel in analysis ('row_pixel', 'col_pixel'), in the matrix
    %'analysis_matrix'
    N = neighborhood (analysis_matrix,row_pixel, col_pixel,neighbor_matrix);
    num_elements = length(N);
    %Addition of a 0 to the center of vector 'N'
    N = [N(1:(num_elements/2)); 0;  N((num_elements/2 + 1):num_elements)];
    %Transformation of vector 'N' into a square matrix of dimension 
    %'dim_neighborhood' 
    N = reshape(N,dim_neighborhood,dim_neighborhood);
    
    %Positions of the pixels, in the neighborhood of dimension 'dim_neighborhood' 
    %of the pixel in analysis ('row_pixel', 'col_pixel'), that are equal to 1
    [L, C] = find(N == 1);
    if (isempty(L) == 0)
        for i = 1 : length(L)
            %Removes the pixels that are equal to 1 from  the 'analysis_matrix',
            %considering their correspondent positions
            analysis_matrix(row_pixel + (L(i) - center_point) , col_pixel + (C(i)- center_point)) = 0;
        end     
   end
        
   resultant_matrix = analysis_matrix;
end