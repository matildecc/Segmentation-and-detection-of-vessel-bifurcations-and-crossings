function connectedCandidates = connectionCenterLineCandidates(centerLineCandidates, alfa)

    %connectionCenterLineCandidates connects the center line candidates
    %based on a region growing process.
    % 
    % INPUTS: 
    %   - centerLineCandidates -> Center lines of one direction
    %   - alfa -> Value that is used to calculate Tseed
    % OUTPUTS:
    %   - connectedCandidates-> Image with the segments that correspond to
    %   vessels conected
    %
    %  Date: 10/05/2021 
    
    centerLineCandidates_vector = centerLineCandidates(:);
    %thresholds are calculated based on only with candidates
    mean_clc = mean(centerLineCandidates_vector(centerLineCandidates_vector>0));
    std_clc = std(centerLineCandidates_vector(centerLineCandidates_vector>0));
    Tseed = mean_clc - alfa*std_clc;
    Taggreg = mode(centerLineCandidates_vector(centerLineCandidates_vector>0));
    [connectedCandidates, ~, ~,~] = regiongrow(centerLineCandidates, (centerLineCandidates>Tseed), abs(Taggreg - Tseed));

end
