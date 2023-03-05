function normalizedImage = backgroundNormalization(img_green_with_padding)

    %backgroundNormalization calculates the normalizedImage, which is 
    %an image without the background.
    % 
    % INPUTS: 
    %   - img_green_with_padding -> Image of the green channel with padding
    % OUTPUTS:
    %   - normalizedImage -> Result of the input image without background
    %
    %  Date: 18/05/2021 
    
    mean_filter = fspecial('average', 31);
    background = imfilter(img_green_with_padding, mean_filter, 'conv');
    normalizedImage = imsubtract(background,img_green_with_padding);
    min_normalizedImage = min(min(normalizedImage)); % only have positive intensities
    normalizedImage = normalizedImage + abs(min_normalizedImage);
end
