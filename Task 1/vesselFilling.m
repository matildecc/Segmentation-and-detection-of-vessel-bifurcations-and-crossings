function filled_seed  = vesselFilling(validated_candidates, reconstructed_vessels)

    %vesselFilling performs a region growing process, which expands the
    %validated candidates into the reconstructed vessels, in an iterative
    %approach
    % INPUTS: 
    %   - validated_candidates -> Center line vessels
    %   - reconstructed_vessels -> Full vessels with some noise
    % OUTPUTS:
    %   - filled_seed -> Result image
    %
    %  Date: 13/05/2021 
    
    seed = validated_candidates;
    % aggregagtion matrix is zero on seed points and on seed points and
    % negative on the others
    aggregation = (~((reconstructed_vessels{1} + seed)>0)).*(-15); 
    [seed, ~, ~, ~] = regiongrow(true(size(seed)),seed,aggregation); % the choice for these inputs are better understand in the regiongrow function 
   
    for iteration = 2:4
        seed = (seed > 0);
        aggregation = (~((reconstructed_vessels{iteration} + seed)>0)).*(-15);
        [seed, ~, ~, ~] = regiongrow(true(size(seed)), seed, aggregation);
    end
    filled_seed  = (seed>0);
end