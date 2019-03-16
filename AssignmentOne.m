%% Ronan Hayes - Assignment One
clc;
clear;
close all;

%% Images
% Read in all three images
img1 = imread('img1.jpg');
img2 = imread('img2.jpg');
penguins = imread('Penguins.jpg');

%% Resize image2
% Here I am creating a variable with the dimensions of image 1.
% I am then assinging image 2 the dimensions using imresize function.
dimensions = size(img1);
dimensions = dimensions(1:2);
resized = imresize(img2,dimensions);

%% Remove noise
% I set a filter value first and then seperate the image into three
% colour channels and apply median filter. 
filterValue = 20;
noiseRemoved(:,:,1) = medfilt2(resized(:,:,1),[filterValue filterValue]);
noiseRemoved(:,:,2) = medfilt2(resized(:,:,2),[filterValue filterValue]);
noiseRemoved(:,:,3) = medfilt2(resized(:,:,3),[filterValue filterValue]);

%% White areas
% First I set a threshold for the white pixels within the image. I then
% created a mask and set it to be false everywhere. I then started to
% create individual missing area masks using their X,Y positions. I then
% created a matrix of 1 and 0 for each white areas. I was then able to use
% repmat to replicate the mask across the colour channels. I could then
% copy the mask from img2 into img1. This gave me the recovered image. 
whitePixels = all(img1 > 220, 3);         
missingSection = false(size(whitePixels));     
missingSection(1:200, 1:150)     = true;       
missingSection(1:80, 120:320)    = true;       %1st area part2
missingSection(535:590, 140:316) = true;       %2nd area
missingSection(546:589, 316:368) = true;       %2nd area part3
missingSection(81:191, 441:481)  = true;       %3rd area
missingSection(105:274, 725:950) = true;       %4th area
missingSection(630:740, 720:900) = true;       %5th area
fillAreas = whitePixels & missingSection;      
rgbfillmask = repmat(fillAreas, [1 1 3]);     
img1(rgbfillmask) = noiseRemoved(rgbfillmask); 
recovered = img1;
figure, imshow(recovered);

%% Similarity
% I used the Structural Similarity Index to find the difference in images.
% It measures each pixel from one image to the reference. 
[ssimval, ssimmap] = ssim(penguins,recovered); 
SimilarityScore = ssimval * 100;
fprintf('The Similarity Score value is %0.4f / 100\n',SimilarityScore) 

%% Limitations
% 1) The first limitation I had was removing the noise from image2. I found
% this to be one of the hardest parts as I tried many different filters
% such as imgaussfilt, wiener2, imbilatfilt and a neural network. However,
% the median filter semed to deliver the highest similarity score for me. I
% had to balance between noise and blur. If i could of found a way to
% remove the noise without so much blur it would have been much better. 

% 2) The second limitation of the program is the detection of white areas.
% I had to hard code the indivudal areas to try and improve my score,
% rather than allow to program to search the entire image matrix. If more
% noise was removed then my original code whereby I searched the entire
% matrix would have been faster and more efficient. 
