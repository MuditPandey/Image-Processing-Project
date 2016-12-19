% demo_blur_detection -- demo for just noticeable blur detection in for a given input
%
%   The Code is created based on the method described in the following paper 
%   [1] "Just Noticeable Defocus Blur Detection and Estimation", 
%       Jianping Shi, Li Xu, Jiaya Jia,
%       IEEE Conference on Computer Vision and Pattern Recognition, 2015. 
%   The code and the algorithm are for non-comercial use only.
%  
%   Author: Jianping Shi (jpshi@cse.cuhk.edu.hk)
%   Date  : 03/20/2015 
%   Copyright 2015, The Chinese University of Hong Kong.
% 

clear all;close all;
addpath('utils');
addpath('bilateral');
addpath('UGM');
addpath('ksvdbox13');

load dict128Blur.mat;

%% Load data, set is Progagation=true if the original feature map contains obvious holes, otherwise false.
% Case #1
im = imread('C:\\Users\\mudit\\Desktop\\Image Processing\\trainResize\\trainR1.jpg');
isPropagation =true;

% Case #2
% im = imread('2.jpg');
% isPropagation = false;

%figure,imshow(im, []);
if (ndims(im) == 3)
    im = rgb2gray(im);
end
im = double(im);

%% Compute original feature map
params.dict = D;
params.x = im;
params.maxatoms = 64;
params.sigma = 2;

rawMap = ompdenoise2(params,5);
params.maxatoms = max(rawMap(:));
%figure,imshow(rawMap, [1, params.maxatoms])

H = fspecial('gaussian', [5, 5], 1);
newMap = im(4:end-4,4:end-4)/255;

%% Feature Propagation
if (isPropagation)
    idx = (rawMap > 3);
    se = strel('disk',2);
    idx = imerode(idx,se);
    sigma_s = 15;
    sigma_r = 0.15;
    D = RF(rawMap.*idx, sigma_s, sigma_r, 3, imfilter(newMap, H));
    F = RF(double(idx), sigma_s, sigma_r, 3, imfilter(newMap, H));
    finalMap = bilateralC(D./F, imfilter(newMap, H), 5, 0.1);
else
    finalMap = RF(rawMap, 10, 0.2, 3, imfilter(newMap, H));
end

%% Final Result
figure,imshow(finalMap, []);
averagedepth=blockproc(finalMap,[32 32],@(x)mean2(x.data));
disp(averagedepth);
%disp(mean2(finalMap));

