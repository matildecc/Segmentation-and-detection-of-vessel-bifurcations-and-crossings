function vesselEnhancedImgs = vesselEnhancemnt(normalizedImage, fov)

    %vesselEnhancemnt calculates four images for each normalizedImage.
    %First, it calculates 8 different top_hats with different disk radius.
    %And then, it makes a mean, two by two. The objective is to detect the
    %thin, medium, large, and big vessels.
    % INPUTS: 
    %   - normalizedImage -> The normalized image
    %   - fov -> The field of view mask decreased
    % OUTPUTS:
    %   - vesselEnhancedImgs -> Result of this adaptive top_hat
    %
    %  Date: 13/05/2021 
    
    se_close = strel('disk', 1);
    addapted_top_hat = cell(1,8);
    for radius = 1:1:8
        se_open = strel ('disk', radius);   
        addapted_top_hat{radius} = normalizedImage - min(imopen(imclose(normalizedImage, se_close),se_open),normalizedImage); 
    end

    vesselEnhancedImgs{1} = ((addapted_top_hat{1} + addapted_top_hat{2})./2).*fov;
    vesselEnhancedImgs{2} = ((addapted_top_hat{3} + addapted_top_hat{4})./2).*fov;
    vesselEnhancedImgs{3} = ((addapted_top_hat{5} + addapted_top_hat{6})./2).*fov;
    vesselEnhancedImgs{4} = ((addapted_top_hat{7} + addapted_top_hat{8})./2).*fov;
end
