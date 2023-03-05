function reconstructedVessels = vesselSegmentReconstruction(addaptedTopHatImg, maskLim, markerLim)

    % vesselSegmentReconstruction returns the image resulted from
    % morphological reconstruction
    % from addaptedTopHat Image. 
    % The marker and the mask are obtained by a binarization with thresholds calculated by
    % histogram percentages from the addaptedTopHat Image
    %
    % 
    % INPUTS: 
    %   - addaptedTopHatImg -> Four images resulted from the adpative
    %   top_hats.
    %   - maskLim -> The value that dictates how much percetange of high
    %   intesities that will make the growing image
    %   - markerLim -> The value that dictates how much percetange of high
    %   intesities that will make the seed image
    % OUTPUTS:
    %   - reconstructedVessels -> Four images that contains the small,
    %   medium, larger, and big vessels

    %  Date: 13/05/2021 
    
    [counts, intensities] = imhist(addaptedTopHatImg);
    accumulatedHist = cumsum(counts);
    accumulatedHist = (counts>0).*accumulatedHist;

    T1 = min(intensities(accumulatedHist >= (1 - maskLim)*max(accumulatedHist)));
    T2 = min(intensities(accumulatedHist >= (1- markerLim)*max(accumulatedHist)));

    marker = imbinarize(addaptedTopHatImg, T2);
    mask = imbinarize(addaptedTopHatImg, T1);
    reconstructedVessels = im2double(imreconstruct(marker, mask));

end