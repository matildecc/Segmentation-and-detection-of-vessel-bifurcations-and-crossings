function final_segmented_image  = finalCorrection(filled_seed)

    %finalCorrection adjust the final image by removing the pixels which
    %have only one pixel neaby and including the non-segmented pixels which have 6 pixels
    %nearby. Besides that, performs a closing with a disk with radius of
    %two.
    % INPUTS: 
    %   - filled_seed -> Image with no correction
    % OUTPUTS:
    %   - final_segmented_image -> Final image
    %
    %  Date: 13/05/2021 
    
    final_segmented_image = filled_seed;
    neighboorhood_kernel = [ 1 1 1;1 0 1; 1 1 1];
    segmentedAux = imfilter(im2double(final_segmented_image), im2double(neighboorhood_kernel), 'conv');

    for iteration = 1:2
         final_segmented_image(segmentedAux >= 6 & final_segmented_image == 0) = 1;
         final_segmented_image(segmentedAux <= 1 & final_segmented_image == 1) = 0;
         segmentedAux = imfilter(im2double(final_segmented_image), im2double(neighboorhood_kernel), 'conv');
    end
    se = strel('disk', 2);
    final_segmented_image = imclose(final_segmented_image,se);
end