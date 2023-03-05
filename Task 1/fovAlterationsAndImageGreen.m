function [FOV_increased, FOV_decreased, img_green_with_padding] = fovAlterationsAndImageGreen(fov, orig_img, num_row, num_col)
    
    %fovAlterationsAndImageGreen calculates new fov masks (FOV_increased and
    %FOV_decreased). The FOV_decreased is obtained by decreasing the FOV mask by
    % 3 rows and 3 collums of the boundaries.The FOV_increased is obtained y
    % increasing the FOV_decreased until some point touches the border of the image.
    % These new FOV masks are important to calculate the green channel of the image
    % with a replicate padding. 
    % 
    % INPUTS: 
    %   - fov -> the field of view for each image (binary image)
    %   - origi_img -> The original image
    % OUTPUTS:
    %   - FOV_increased -> Larger field of view mask, compared with fov
    %   - FOV_decreased -> Smaller field of view mask, compared with fov
    %   - img_green_with_padding -> Green channel image with padding
    %
    %  Date: 18/05/2021 

    %Initialize FOV_decreased
    FOV_decreased = fov;
    
    %Calculate FOV Reduction
    for iteration=1:3
        B = bwboundaries(FOV_decreased,'noholes');
        for boundary_point = 1:length(B{1})
            row = B{1}(boundary_point,1);
            col = B{1}(boundary_point,2);
            for i =-1:1:1
                for j = -1:1:1    
                    FOV_decreased(row+i,col+j) = 0;
                end
            end
        end
    end
    
    %Calculate the new green Image (without the white lines), that will be
    %padded
    img_green_with_padding = orig_img(:, :, 2).*FOV_decreased;  
    
    %Initialize FOV_increased
    FOV_increased = FOV_decreased;
    
    % Calculate the FOV increased and the new image with the padding
    while (max(row)+3 <= num_row && min(row)-3 >=0 && max(col)+3 <=num_col && min(col)-3 >=0)
       B = bwboundaries(FOV_increased,'noholes');
       row = zeros(1,length(B{1}));
       col = zeros(1,length(B{1}));
       
       for boundary_point = 1:length(B{1})
            row(boundary_point) = B{1}(boundary_point,1);
            col(boundary_point) = B{1}(boundary_point,2);
            for i =-1:1:1
                for j = -1:1:1
                    if (img_green_with_padding(row(boundary_point)+i,col(boundary_point)+j) == 0)
                        img_green_with_padding(row(boundary_point)+i,col(boundary_point)+j) = img_green_with_padding(row(boundary_point),col(boundary_point));
                        FOV_increased(row(boundary_point)+i,col(boundary_point)+j) = 1;
                    end
                end
            end
       end 
    end  
end