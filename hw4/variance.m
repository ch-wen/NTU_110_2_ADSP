function  var = variance(img)
    u = mean(img,'all');
    tmp = (img-u).^2;
    [M,N] = size(img);
    var = (sum(tmp,'all'))/(M*N);
end