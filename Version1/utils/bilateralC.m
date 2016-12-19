function image_out = bilateralC(image, edge, sigma_s, sigma_r)
% strImg = 'inputblf2013.png';
% strOut = 'outputblf2013.png';
% strEdge = 'edgeblf2013.png';
%  
% strsigmas  = num2str(sigmas);
% strsigmar  = num2str(sigmar);
% imwrite(im, strImg);
% imwrite(edge, strEdge);
cd('bilateral');
save('in.mat', 'image', 'edge', 'sigma_s', 'sigma_r');
system('permutohedral.exe -m in.mat out.mat');
% retImg = im2double((imread(strOut)));
load out.mat
cd('..');
% system(['del ',strImg]);
% system(['del ',strEdge]);
% system(['del ',strOut]);
% system('del in.mat');
% system('del out.mat');
end