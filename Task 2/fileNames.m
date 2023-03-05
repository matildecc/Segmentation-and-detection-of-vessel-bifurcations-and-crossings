%FUNCTION: fileNames

%Function that returns the file name of a given image ('img_filename')and
%correspondent GT points' excel file ('xlx_filename'), accordingly to the
%order number of the image ('itr') and the respective set of images
%to which it belongs ('num').

%Note: 
%num = 1 --> It corresponds to the set of training images
%num = 2 --> It corresponds to the set of test images

function [img_filename, xls_filename] = fileNames(itr, num)

if (num == 1) %Set of training images
    img_filename = strcat(int2str(itr + 20),'_training.png');
    xls_filename = strcat(int2str(itr + 20),'_training.xls');
    
elseif(num == 2) %Set of test images
    if (itr < 10)
        img_filename = strcat('0',int2str(itr),'_test.png');
        xls_filename = strcat('0',int2str(itr),'_test.xls');
    else
        img_filename = strcat(int2str(itr),'_test.png');
        xls_filename = strcat(int2str(itr),'_test.xls');  
    end  

end

end