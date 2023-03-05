function enhancedImage = thinVesselEnhancement(image)

    %thinVasselEnhancement increases the contrast of thin vessels, applying
    %a filter [3 x 3] in four different directions.
    % 
    % INPUTS: 
    %   - image -> The normalized Image
    % OUTPUTS:
    %   - enhancedImage -> Image with more contrast in thin vessels
    %
    %  Date: 13/05/2021 
    
    kernel_tve = (1/6).*[-1, -1, -1; 2, 2, 2; -1, -1, -1];
    enhancementOneDirectionImage = cell(1,4);

    for angle=0:45:135
        w_final = imrotate(kernel_tve, angle);
        if (rem(angle, 90) ~=0)
           w_final = w_final(2:4, 2:4); 
        end
        enhancementOneDirectionImage{((angle)/45)+1} = imfilter(image, w_final,'replicate', 'conv');
    end

        maxEnhancementResponseImage = max(max(enhancementOneDirectionImage{1},enhancementOneDirectionImage{2}), max(enhancementOneDirectionImage{3}, enhancementOneDirectionImage{4}));
        enhancedImage  =  (maxEnhancementResponseImage + image);
end