%FUNCTION: intersectionNum

%Function that creates/returns a matrix with the values of the intersection
%number ('I_matrix') calculated for each pixel of the zero-padded image 
%matrix 'Img_ZP'. The intersection number I(P) is calculated for each pixel
%P using the following equation:

%I(P) = 1/2 * summation from i=1 until i=8 of ( abs(N[i](P) - N[i+1](P)) )

%N[i](P) are the neighbours of the analysed point, P, named clockwise
%consecutively.

function I_matrix = intersectionNum(Img_ZP) %NOTE: name adaptation!

[lines, cols] = size(Img_ZP);

%Previous space allocation for 'I_matrix'
I_matrix = zeros(lines - 2, cols - 2) ;

% Goes through the zero-padded image 'Img_ZP'
for L = 2 : (lines - 1)
    
    for C = 2 : (cols - 1)
        
        % Vector with the 8-neighborhood of each pixel (coordinates: L,C)
        N8_pixel = [Img_ZP(L-1, C-1 : C+1), Img_ZP(L, C+1), Img_ZP(L+1, C+1:-1:C-1), Img_ZP(L, C-1)];
        
        % Calculus of the intersection number, for each pixel - I(L,C)
        summation = 0;
        for i = 1 : (length(N8_pixel) - 1)
            summation = summation + abs(N8_pixel(i) - N8_pixel(i+1));
        end
        intersection_num = 1/2 * (summation + abs(N8_pixel(end) - N8_pixel(1)));
        
        % Matrix with the correspondent intersection numbers for each pixel
        I_matrix(L - 1, C - 1) = intersection_num;
    end
end

end