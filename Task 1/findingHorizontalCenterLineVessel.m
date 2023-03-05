function horizontalCenterLineCandidates = findingHorizontalCenterLineVessel(DoOG0, TVEImage )
    
    %findingHorizontalCenterLineVessel calculates Horizontal center line vessels
    %by detecting the different variations: (++--,++-~ and mean>0,~+-- and mean<0,+0-)
    % + -> positive
    % - -> negative
    % ~ -> positive or negative
    % 0 -> zero
    % So, the Doog was calculated using 0º in order to obtain this
    % variations, when the rows are changing from top to bottom and the collums
    % are changing from left to right.
    %Looking-for pattern :
    %++-- or ++-~ and mean>0 or ~+-- and mean<0 or +0-
    % INPUTS: 
    %   - DoOG0 -> Doog obtained with 0º kernel
    %   - TVEImage -> Thin vessel enhancement image
    % OUTPUTS:
    %   - horizontalCenterLineCandidates -> Vertical candidates segments
    %
    %  Date: 13/05/2021 
    
    [rows, columns] = size(DoOG0);
    horizontalCenterLineCandidates = zeros(rows, columns);   

    for r=1:rows
        for c=1:columns - 3
            segment2analyse = DoOG0(r,c:c+3);
            if(( segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0) || (segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) > 0 && sum(segment2analyse) > 0 ) || (segment2analyse(1) < 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0 && sum(segment2analyse) < 0) )
                [~, i] = max(TVEImage(r,c:c+3));
                horizontalCenterLineCandidates(r, c + i - 1) = max(segment2analyse) + abs(min(segment2analyse));
            elseif(( segment2analyse(1) > 0 && segment2analyse(2) == 0 && segment2analyse(3) < 0 ))
                [~, i] = max(TVEImage(r,c:c+2));
                horizontalCenterLineCandidates(r, c + i - 1) = segment2analyse(1) + abs(segment2analyse(3));
            end   
        end
    end
end
