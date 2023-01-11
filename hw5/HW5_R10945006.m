%% Number theoretic transform matrices(NTTm)

% Student name: Chieh-Hsun, Wen
% Student Id:   R10945006

% ADSP HW5 (1), generate the foward and inverse N-point NTTm
% Beside basic function, four additional function
% 1. Smallest positive alpha
% 2. Is able to run for large N
clear;clc;

while(1)
    M = input('M (Must be prime number): ');
    if(isprime(M)==1)
        break;
    end
end
N = input('N: '); 

[foward, inverse] = NTTm(N, M);
orthogonal = mod(foward*inverse,M);

function [foward,inverse] = NTTm(N,M)
    foward = 0;
    inverse = 0;
    alpha = 0;
    inalpha = 0;
    inN = 0;
    % alpha
    while (((mod(alpha^N,M)~=1)||check~=0)&&alpha<=M-1)   
        alpha = alpha+1;
        asNmM = mod(sym(alpha).^sym((1:N-1)),sym(M));
        check = any(asNmM(:) == 1);
        if(alpha==M)
            disp('Alpha=M');
            return;
        end
    end
    foward = zeros(N,N);
    inverse = foward;
    for i = 1:N
        for j = 1:N
            foward(i,j) = double(mod(sym(alpha)^sym(((i-1)*(j-1))),sym(M)));
        end
    end
    % alpha-
    while((mod(alpha*inalpha,M) ~= 1))
        inalpha = inalpha + 1;
    end
    % N-
    while((mod(N*inN,M) ~= 1)) 
        inN = inN + 1;
    end
    for i = 1:N
        for j = 1:N
            inverse(i,j) = double(mod(sym(inN)*(sym(inalpha)^sym(((i-1)*(j-1)))),sym(M)));
        end
    end
end