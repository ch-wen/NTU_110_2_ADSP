function covarxy = covariancexy(imgx,imgy)
    avgx = mean(imgx,'all');
    avgy = mean(imgy,'all');
    tmp = (imgx-avgx).*(imgy-avgy);
    [M,N] = size(imgx); %x,y is with the same size
    covarxy = (sum(tmp,'all'))/(M*N);
end