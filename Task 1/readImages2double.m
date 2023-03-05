function [images, FOV, GT] = readImages2double(nameImagesFolder, nameFOVFolder, nameGTFolder, imagesPath, FOVPath, GTPath)

    %readImages2double performs the images and fovs extraction from a specific
    %path and converts the images do double type. 
    % 
    % INPUTS: 
    %   - nameImagesFolder -> the name of the folder that contains the images
    %   to extract
    %   - nameFOVFolder -> the name of the folder that contains the 
    %   field of view(FOV) mask of the images to extract
    %   - imagesPath - the path in the user computer of the images file location 
    %   - FOVPath - the path in the user computer of the FOV file location 
    % OUTPUTS:
    %   - images -> cell array containing all the images extracted from the image
    %   folder
    %   - FOV -> cell array containing all the FOV extracted from the FOV
    %   folder
    %   
    %  Date: 13/05/2021 

    imagesFolder = dir(nameImagesFolder);
    FOVFolder = dir(nameFOVFolder);
    GTFolder = dir(nameGTFolder);
    imagesPath = strcat(imagesPath, '\');
    FOVPath = strcat(FOVPath, '\');
    GTPath = strcat(GTPath, '\');
    images = {};
    FOV = {};

    for i = 1: (length(imagesFolder)-2)
       images{i} = im2double(imread(strcat(imagesPath,imagesFolder(i+2).name)));
       FOV{i} = im2double(imread(strcat(FOVPath,FOVFolder(i+2).name)));
       GT{i} = im2double(imread(strcat(GTPath,GTFolder(i+2).name)));
    end
end

