%FUNCTION: zeroPadding

%Function that creates/returns the resultant matrix of 1-pixel-width
%zero-padding ('Img_ZP'), applied to the matrix 'Img_matrix'.

function Img_ZP = zeroPadding(Img_matrix) 

[lines, cols] = size(Img_matrix);

% Adds two lines of zeros to 'Img_matrix'
Img_ZP = [zeros(1,cols); Img_matrix; zeros(1,cols)];

% Adds two columns of zeroes to 'Img_matrix'
Img_ZP = [zeros(lines + 2,1), Img_ZP, zeros(lines + 2,1)];

end