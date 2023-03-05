function [TP, TN, FP, FN] = metrics2segmentation(segmentatedImg, groundTruth, FOV)

%TP - number of True Positive points
%TN - number of True Negative points
%FP - number of False Poisitive points
%FN - number of False Negative points

TP = sum(sum((groundTruth + segmentatedImg) == 2 & FOV> 0));
TN = sum(sum((groundTruth + segmentatedImg) == 0 & FOV> 0));

FP = sum(sum(((groundTruth + segmentatedImg) == 1 & segmentatedImg == 1& FOV> 0)));
FN = sum(sum(((groundTruth + segmentatedImg) == 1 & groundTruth == 1 & FOV> 0 )));

end



    

