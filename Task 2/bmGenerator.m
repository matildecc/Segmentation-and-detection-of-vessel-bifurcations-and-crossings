%FUNCTION: bmGenerator

%Function that creates/returns a square matrix ('border_matrix') with size
%'size_bm' of zeros, except on its borders (the 1-pixel-width borders of 
%the matrix are filled with ones)

%Example:
%border_matrix = bmGenerator(5) =

% 1 1 1 1 1 
% 1 0 0 0 1 
% 1 0 0 0 1 
% 1 0 0 0 1 
% 1 1 1 1 1 

function border_matrix = bmGenerator(size_bm) 

        border_matrix = [ones(1,size_bm-2); zeros(size_bm-2, size_bm-2); ones(1,size_bm-2)];
        border_matrix = [ones(size_bm,1), border_matrix, ones(size_bm,1)];
end
