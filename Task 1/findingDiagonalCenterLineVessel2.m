function diagonalCenterLineCandidates2 = findingDiagonalCenterLineVessel2(DoOG45, TVEImage )
    
    %diagonalCenterLineCandidates2 calculates Diagonal center line vessels
    %by detecting the different variations: (++--,++-~ and mean>0,~+-- and mean<0,+0-)
    % + -> positive
    % - -> negative
    % ~ -> positive or negative
    % 0 -> zero
    % So, the Doog was rotated 45º in order to obtain this
    % variations, when the rows are changing from top to bottom and the collums
    % are changing from left to right.
    % % Looking-for pattern:
    %      -           ~         -      
    %     -  or      -  or     -   or    -
    %   +          +         +          0
    % +         +          ~          +
    %         (mean>0)    (mean<0)
    % INPUTS: 
    %   - DoOG45 -> Doog obtained with 45º kernel
    %   - TVEImage -> Thin vessel enhancement image
    % OUTPUTS:
    %   - diagonalCenterLineCandidates2 -> Diagonal2 candidates segments
    %
    %  Date: 13/05/2021 


    [rows,columns] = size(DoOG45);
    diagonalCenterLineCandidates2 = zeros(rows,columns);
    kernel2analyse = [0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0];  

    for r=1:rows - 3
        for c=1:columns - 3
            segment2analyse = diag(flip((DoOG45(r:r+3,c:c+3).*kernel2analyse))); %the diagonal is extracted for a row vector
            if((segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0) || (segment2analyse(1) > 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) > 0 && sum(segment2analyse) > 0) || (segment2analyse(1) < 0 && segment2analyse(2) > 0 && segment2analyse(3) < 0 && segment2analyse(4) < 0 && sum(segment2analyse) < 0 ))
                [~, i] = max(diag(flip(TVEImage(r:r+3,c:c+3).*kernel2analyse)));
                diagonalCenterLineCandidates2(r + 4 - i, c + i - 1) = max(segment2analyse) + abs(min(segment2analyse));
            elseif (segment2analyse(1) > 0 && segment2analyse(2) == 0 && segment2analyse(3) < 0)
                [~, i] = max(diag(flip(TVEImage(r+1:r+3,c:c+2).*kernel2analyse(2:4,1:3))));
                diagonalCenterLineCandidates2(r + 4 - i, c + i - 1) = segment2analyse(1) + abs(segment2analyse(3));
            end
        end
    end
end
