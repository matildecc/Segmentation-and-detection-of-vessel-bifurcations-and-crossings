%% Main - Segmentation 
% By Matilde Carvalho Costa and João Santos Sousa Alves
% Addpated approach by A. M. Mendonca and A. Campilho, Segmentation of retinal blood vessels by combining the detection of
%centerlines and morphological reconstruction, IEEE Transactions on Medical Imaging, vol. 25, no. 9, pp. 1200-
%1213, Sept. 2006, doi: 10.1109/TMI.2006.879955.

%% Clear the workspace, the command window and close all the images
clear
clc
close all
tic

%% Parameters Intialization
threshold_factor = 0.6;
alfa = -0.7;
min_n_points = 18;
percentage_seed = [0.1*(3/10), 0.08*(3/10), 0.05*(3/10), 0.03*(3/ 10)] ;
percentage_grow = [0.1, 0.08, 0.05, 0.03];


%%  Reading and doubling the images and FOVs

% the name of the folders and the paths should be change before running the
% program
[orig_img, FOV, GT] = readImages2double('images', 'fov', 'vessel','C:\Users\jalve\Desktop\PC\João\Escola\FEUP\3ºano\2ºSemestre\AIBI\Projeto\Para Pensar - AIBI\images','C:\Users\jalve\Desktop\PC\João\Escola\FEUP\3ºano\2ºSemestre\AIBI\Projeto\Para Pensar - AIBI\fov','C:\Users\jalve\Desktop\PC\João\Escola\FEUP\3ºano\2ºSemestre\AIBI\Projeto\Para Pensar - AIBI\vessel');

%% Ask the user for the images that he want to segment
disp(['The range of images is: 1-' num2str(length(FOV)) '. What is the range of images that you want to segment?'])
first_image = input('First Image:');
while (first_image <=1 || first_image > length(FOV))
    first_image = input('Value not allowed. Try again:');
end
final_image = input('Final Image:');
while (final_image <1 || final_image > length(FOV))
    final_image = input('Value not allowed. Try again:');
end

num_images = final_image - first_image + 1;

%% Calculating the size of each image (channel green)
num_row = zeros(1, num_images);
num_col = zeros(1, num_images);

for img_i = first_image:final_image
    [num_row(img_i), num_col(img_i)] = size(orig_img{img_i}(:,:,2));
end

%% Adjusting the FOV mask, obtaining and padding Image green channel 
img_green_with_padding = cell(1, num_images);
FOV_decreased = cell(1, num_images);
FOV_increased = cell(1, num_images);

for img_i = first_image:final_image
    [FOV_increased{img_i}, FOV_decreased{img_i}, img_green_with_padding{img_i}] = fovAlterationsAndImageGreen(FOV{img_i}, orig_img{img_i}, num_row(img_i), num_col(img_i));
end

%% Background normalization
normalised = cell(1, num_images);

for img_i=first_image:final_image
   normalised{img_i} = backgroundNormalization(img_green_with_padding{img_i});
end

%%  Thin Vessel Enhancement - 4 angles: 0, 45, 90, 135
tve = cell(1, num_images);

for img_i=first_image:final_image
   tve{img_i} = thinVesselEnhancement(normalised{img_i});
end

%% Multiscale morpholofical enhancement
enhanced_vessel = cell(num_images, 4);

for img_i = first_image:final_image
    enhanced_vessel{img_i} = vesselEnhancemnt(normalised{img_i}, FOV_decreased{img_i});
end

%% Multiscale Reconstruction
reconstructed_vessels = cell(num_images, 4);

for img_i = first_image:final_image
    reconstructed_vessels{img_i}{1} = vesselSegmentReconstruction(enhanced_vessel{img_i}{1}, percentage_grow(1), percentage_seed(1));
    reconstructed_vessels{img_i}{2} = vesselSegmentReconstruction(enhanced_vessel{img_i}{2}, percentage_grow(2), percentage_seed(2));
    reconstructed_vessels{img_i}{3} = vesselSegmentReconstruction(enhanced_vessel{img_i}{3}, percentage_grow(3), percentage_seed(3));
    reconstructed_vessels{img_i}{4} = vesselSegmentReconstruction(enhanced_vessel{img_i}{4}, percentage_grow(4), percentage_seed(4));
end

%% First order derivative filter - DoOG (4 directions 0, 45, 90, 135)
DoOG = cell(num_images, 4);

for img_i =first_image:final_image
    DoOG{img_i} = DoOGFilter4Directions(tve{img_i}, FOV_decreased{img_i});
end
%% Centerline Candidates  seletion - finding a pattern
center_line_candidates = cell(num_images, 4);

for img_i=first_image:final_image
    % ANGLE -90
    center_line_candidates{img_i}{1} = findingVerticalCenterLineVessel(DoOG{img_i}{1},tve{img_i});
    % ANGLE -45
    center_line_candidates{img_i}{2} = findingDiagonalCenterLineVessel1(DoOG{img_i}{2}, tve{img_i});
    % ANGLE 0
    center_line_candidates{img_i}{3} = findingHorizontalCenterLineVessel(DoOG{img_i}{3}, tve{img_i});  
    % ANGLE 45
    center_line_candidates{img_i}{4} = findingDiagonalCenterLineVessel2(DoOG{img_i}{4},tve{img_i});
end

%% Connection of Candidate Points
connected_center_line_candidates = cell(num_images, 4);

for img_i=first_image:final_image
    % ANGLE -90
    connected_center_line_candidates{img_i}{1} = connectionCenterLineCandidates(center_line_candidates{img_i}{1}, alfa);
    % ANGLE -45
    connected_center_line_candidates{img_i}{2} = connectionCenterLineCandidates(center_line_candidates{img_i}{2}, alfa);    
    % ANGLE 0
    connected_center_line_candidates{img_i}{3} = connectionCenterLineCandidates(center_line_candidates{img_i}{3}, alfa);
    % ANGLE 45
    connected_center_line_candidates{img_i}{4} = connectionCenterLineCandidates(center_line_candidates{img_i}{4}, alfa);
end

%% Elimination of segments with less than min_nPoints
connected_center_line_candidates_corrected = cell(1, num_images);

for img_i = first_image:final_image
    connected_center_line_candidates_corrected{img_i} = eliminationSmallSegments(connected_center_line_candidates{img_i}, min_n_points);
end

%% Validation of segment candidates
validated_candidates = cell(1, num_images);

for img_i=first_image:final_image
    validated_candidates{img_i} = validationSegmentCandidates(connected_center_line_candidates_corrected{img_i}, tve{img_i}, threshold_factor, num_row(img_i), num_col(img_i));
end

%% Vessel filling 
filled_seed = cell(1, num_images);

for img_i = first_image:final_image
    filled_seed{img_i}  = vesselFilling(validated_candidates{img_i}, reconstructed_vessels{img_i});
end

%% Final correction
final_segmented_image = cell(1, num_images);

for img_i = first_image:final_image
    final_segmented_image{img_i}  = finalCorrection(filled_seed{img_i});
end

%% Display First and Final Images
for img_i = first_image:final_image
    figure, imshow(orig_img{img_i}(:,:,2), []), title(['Initial Image ' num2str(img_i)])
    figure, imshow(final_segmented_image{img_i}, []), title(['Final segmented Image ' num2str(img_i)])
end

%%  Evaluation
sensitivity = cell(1, num_images);
specificity = cell(1, num_images);
accuracy = cell(1, num_images);

 for img_i = first_image:final_image
    [sensitivity{img_i}, specificity{img_i}, accuracy{img_i}] = segmentationEvaluation(final_segmented_image{img_i}.*FOV_decreased{img_i}, GT{img_i}, FOV{img_i});
 end
toc