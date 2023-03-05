function DoOGImages = DoOGFilter4Directions(image, fov)
    
    %DoOGFilter4Direction calculates the result from applying a DoOG
    %Filter, which is a Difference of Offset Gaussian, in four directions (0º, 45º, 90º, 135º).
    %To notice that the angles used are from -90º to 45º because the next
    %functions of finding the centerlines are performed by changing the
    %rows from top to bottom and changing the collums from left to right.
    % 
    % INPUTS: 
    %   - image -> Input Image
    %   - fov -> Field of view decreased
    % OUTPUTS:
    %   - DoOGImages-> Four images result of DoOG (four directions)
    %
    %  Date: 10/05/2021 

    DoOGImages = cell(4);
    DoOGKernel = [-1 -2 0 2 1; -1 -2 0 2 1;-1 -2 0 2 1]; %this kernel enhance variations in vertical vessels 
    %  the -90º rotation of DoOGKernel enhance variations in horizontal vessels 
    %  the -45º rotation of DoOGKernel enhance variations in diagonal vessels of 45º in relation to the horizontal axis
    %  the 45º rotation  of DoOGKernel enhance variations in diagonals vessels of 135º in relation to the horizontal axis
        for angle= -90:45:45
            currentDoGKernel= imrotate(DoOGKernel, angle);
            DoOGImages{((angle)/45)+ 3} = imfilter(image,currentDoGKernel,'replicate');
            DoOGImages{((angle)/45)+ 3} = DoOGImages{((angle)/45)+ 3}.*fov;
        end

end
