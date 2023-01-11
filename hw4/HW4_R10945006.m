%% Structural similarity of two image

% Student name: Chieh-Hsun, Wen
% Student Id:   R10945006

% ADSP HW4 (1), Measure the structural similarity of two image
% The sizes of A and B are equivalent
% Image values must be between 0 to 255

clear;clc;

A = randi([0 255],50,60); % image A
B = randi([0 255],50,60); % image B
L = 255; %255-0
c1 = 1/sqrt(L);
c2 = c1;

if(size(A)==size(B))
    if(max(max(A))>255||min(min(A))<0||max(max(B))>255||min(min(B))<0)
        disp('Image values must be between 0 to 255');
    else
        ssim = SSIM(A,B,c1,c2);
    end
else
    disp('The sizes of A and B are not equivalent');
end
% SSIM
function ssim = SSIM(A,B,c1,c2)
    L = 255;
    ux = mean(A,'all');
    uy = mean(B,'all');
    covarxy = covariancexy(A,B);
    varx = variance(A);
    vary = variance(B);
    ul = 2*ux*uy+(c1*L)^2;
    dl = ux^2+uy^2+(c1*L)^2;
    ur = 2*covarxy+(c2*L)^2;
    dr = varx+vary+(c2*L)^2;
    ssim = (ul/dl)*(ur/dr);
end

