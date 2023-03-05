function [sensitivity, specificity, accuracy] = segmentationEvaluation(segmentatedImg, groundTruth, FOV)
[TP, TN, FP, FN] = metrics2segmentation(segmentatedImg, groundTruth, FOV);
sensitivity = TP/(TP +FN);
specificity = TN/(TN + FP);
accuracy = (TP + TN)/(TP + TN +FP + FN);
end
