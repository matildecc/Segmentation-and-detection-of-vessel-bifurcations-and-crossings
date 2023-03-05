function validated_candidates = validationSegmentCandidates(connected_center_line_candidates_corrected, tve, threshold_factor, num_row, num_col)
    
    %validationSegmentCandidates performs many steps to calculate a feature
    %for each segment that envolves the length and the intesnity, in order
    %to see if it corresponds to noise or a real vessel.( all the steps are
    %explained on  A. M. Mendonca and A. Campilho, Segmentation of retinal blood vessels by combining the detection of
    %centerlines and morphological reconstruction, IEEE Transactions on Medical Imaging, vol. 25, no. 9, pp. 1200-
    %1213, Sept. 2006, doi: 10.1109/TMI.2006.879955).
    % 
    % INPUTS: 
    %   - connected_center_line_candidates_corrected -> Center line Image
    %   - tve -> thin vessel enhanced image
    %   - threshold_factor -> thresgold that dictates which segments dont
    %   go to the validation step
    %   - num_row -> number of rows of the image
    %   - num_col -> number of collums of the image
    % OUTPUTS:
    %   - validated_candidates -> Result image, with fewer segments
    %
    %  Date: 13/05/2021 
    
    max_segment = zeros(1,4);
    validated_set_candidates = cell(1, 4);
    intensity_segment_subset_aux= cell(1, 4);
    intensity_segment_subset= cell(1, 4);
    length_segment_subset_aux= cell(1, 4);
    length_segment_subset= cell(1, 4);
    subset_int = cell(1, 4);
    subset_length = cell(1, 4);
    I_ref = cell(1, 4);
    L_ref = cell(1, 4);
    
    for set=1:4 
        validated_set_candidates{set} = false(num_row, num_col);
        
        %Calculate the number of segments of each set
        max_segment(set) = max(connected_center_line_candidates_corrected{set}(:));
        
        %Caculate each segment intensity
        intensity_segment = zeros(1, max_segment(set));
        for segment=1:max_segment(set)
            mean_intensity_segment = mean(tve(connected_center_line_candidates_corrected{set}==segment));
            max_intensity_segment = max(tve(connected_center_line_candidates_corrected{set}==segment));
            intensity_segment(segment) = geomean([mean_intensity_segment, max_intensity_segment]);
        end
                
        %Caculate threshold
        threshold = threshold_factor*max(intensity_segment);
        
        %Caculate subset intensity      
        for segment=1:max_segment(set)
            if (intensity_segment(segment) > threshold)
                validated_set_candidates{set} = (ones(num_row,num_col)).*(connected_center_line_candidates_corrected{set}==segment) + validated_set_candidates{set};
                intensity_segment_subset_aux{set}(segment) = 0;
                length_segment_subset_aux{set}(segment) = 0;
            else 
                intensity_segment_subset_aux{set}(segment) = intensity_segment(segment);
                length_segment_subset_aux{set}(segment) = sum(sum(connected_center_line_candidates_corrected{set}==segment));
            end
        end
        intensity_segment_subset{set} = intensity_segment_subset_aux{set}(intensity_segment_subset_aux{set} > 0);
        length_segment_subset{set} = length_segment_subset_aux{set}(length_segment_subset_aux{set} > 0);
        
        subset_int{set} = mean(intensity_segment_subset{set}) - std(intensity_segment_subset{set});
        subset_length{set} = mean(length_segment_subset{set});
    end
    
    %Calculate subset intensity global and length subset global
    subset_int_aux = [intensity_segment_subset{1}, intensity_segment_subset{2}, intensity_segment_subset{3}, intensity_segment_subset{4}];
    subset_int_global = mean(subset_int_aux) - std(subset_int_aux);
    
    subset_length_aux = [length_segment_subset{1}, length_segment_subset{2}, length_segment_subset{3}, length_segment_subset{4}];
    subset_length_global = mean(subset_length_aux);
    
    %Calculate the validated set candidates
    for set=1:4
       I_ref{set} = max(subset_int{set}, subset_int_global);
       L_ref{set} = max(subset_length{set}, subset_length_global);
       subset_threshold = I_ref{set}*sqrt(L_ref{set});
       for segment=1:max_segment(set)
           if(intensity_segment_subset_aux{set}(segment) ~=0)
               feature_value = intensity_segment_subset_aux{set}(segment)*sqrt(length_segment_subset_aux{set}(segment));
               if(feature_value >= subset_threshold)
                   validated_set_candidates{set} = (ones(num_row,num_col)).*(connected_center_line_candidates_corrected{set}==segment) + validated_set_candidates{set};
               end
           end
       end
    end
    
    %Calculate the validated candidates
    validated_candidates = validated_set_candidates{1} + validated_set_candidates{2} + validated_set_candidates{3} + validated_set_candidates{4};
    validated_candidates =  validated_candidates > 0;

end