function diagonalCenterLineCandidates1 = findingDiagonalCenterLineVessel1(DoOG_45, TVEImage )

    %diagonalCenterLineCandidates1 calculates Diagonal center line vessels
    %by detecting the different variations: (++--,++-~ and mean>0,~+-- and mean<0,+0-)
    % + -> positive
    % - -> negative
    % ~ -> positive or negative
    % 0 -> zero
    % So, the DoOg was rotated -45º in order to obtain these
    % sequenced variations when the rows are changing from top to bottom and the collums
    % are changing from left to right.
    % Looking-for pattern:
    % +         +           ~         +
    %  +     ou   +    ou    +   ou    0
    %    -          -         -          -
    %     -            ~       -
    %               (mean>0)    (mean<0)
    % INPUTS: 
    %   - DoOG_45 -> Doog obtained with -45º(135º) kernel 
    %   - TVEImage -> Thin vessel enhancement image
    % OUTPUTS:
    %   - diagonalCenterLineCandidates1 -> Diagonal1 candidates segments
    %
    %  Date: 13/05/2021 

    [rows,columns] = size(DoOG_45);
    diagonalCenterLineCandidates1 = zeros(rows,columns);
    kernel2analyse = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

    for r = 1:rows - 3
        for c = 1:columns - 3
            segment2analyse = diag((DoOG_45(r:r+3,c:c+3).*kernel2analyse));%the diagonal is extracted for a row vector
            if((segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0) || (segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) > 0 && sum(segment2analyse) > 0) || (segment2analyse(1) < 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0 && sum(segment2analyse) < 0 ))
                [~, i] = max(diag(TVEImage(r:r+3,c:c+3).*kernel2analyse));
                diagonalCenterLineCandidates1(r+i-1, c+i-1) = max(segment2analyse) + abs(min(segment2analyse));
            elseif (segment2analyse(1) > 0 && segment2analyse(2) == 0 && segment2analyse(3) < 0)
                [~, i] = max(diag(TVEImage(r:r+2,c:c+2).*kernel2analyse(1:3, 1:3)));
                diagonalCenterLineCandidates1(r+i-1, c+i-1) = segment2analyse(1) + abs(segment2analyse(3));
            end
        end
    end

end


