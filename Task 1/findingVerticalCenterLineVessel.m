function verticalCenterLineCandidates = findingVerticalCenterLineVessel(DoOG90,TVEImage)

    %findingVerticalCenterLineVessel calculates Vertical center line vessels
    %by detecting the different variations: (++--,++-~ and mean>0,~+-- and mean<0,+0-)
    % + -> positive
    % - -> negative
    % ~ -> positive or negative
    % 0 -> zero
    % So, the Doog was rotated  -90º in order to obtain this
    % variations, when the rows are changing from top to bottom and the collums
    % are changing from left to right.
    %Looking-for pattern:
    %+      +                ~               +
    %+   or + and mean>0 or  + and mean<0 or 0
    %-      -                -               - 
    %-      ~                -
    % INPUTS: 
    %   - DoOG90 -> Doog obtained with -90º(90º) kernel
    %   - TVEImage -> Thin vessel enhancement image
    % OUTPUTS:
    %   - verticalCenterLineCandidates -> Vertical candidates segments
    %
    %  Date: 13/05/2021 

    [rows, columns] = size(DoOG90);
    verticalCenterLineCandidates = zeros(rows,columns);

    for c = 1:columns
        for r = 1:(rows - 3)
            segment2analyse = DoOG90(r:r+3,c);
            if((segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0) || (segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) > 0 && sum(segment2analyse) > 0)  || (segment2analyse(1) < 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0 && sum(segment2analyse) < 0))
                [~, i] = max((TVEImage(r:r+3,c)));
                verticalCenterLineCandidates( r + i - 1, c) =  max(segment2analyse) + abs(min(segment2analyse));
            elseif(segment2analyse(1) > 0 && segment2analyse(2) == 0 && segment2analyse(3) < 0 )
                [~, i] = max(TVEImage(r:r+2,c));
                verticalCenterLineCandidates(r + i - 1, c) = segment2analyse(1) + abs(segment2analyse(3));
            end   
        end

    end
end
