function connected_center_line_candidates_corrected = eliminationSmallSegments(connected_center_line_candidates, min_n_points)
    
    %eliminationSmallSegments eliminates the segments which have a length
    %value lower that min_n_points
    % 
    % INPUTS: 
    %   - connected_center_line_candidates -> Image with center lines
    %   - min_n_points -> minimum number of points
    % OUTPUTS:
    %   - connected_center_line_candidates_corrected -> Result image
    %
    %  Date: 13/05/2021 

    connected_center_line_candidates_corrected = connected_center_line_candidates;
    
    for set=1:4 
        region_number = 1;
        max_value = max(connected_center_line_candidates_corrected{set}(:)); %number od regions 
        while region_number <= max_value
            if sum(sum(connected_center_line_candidates_corrected{set} == region_number)) < min_n_points
                connected_center_line_candidates_corrected{set}(connected_center_line_candidates_corrected{set} == region_number) = 0;
                connected_center_line_candidates_corrected{set}(connected_center_line_candidates_corrected{set} > region_number) = (connected_center_line_candidates_corrected{set}(connected_center_line_candidates_corrected{set} > region_number)) - 1;
                max_value = max_value - 1;
                region_number = region_number - 1;
            end
         region_number = region_number + 1;
         end
    end
end