function kernels0 = get_kernels0(radius, type)
% Get 8 kernels of different side windows
% L, R, U, D, NW, NE, SW, SE
r = radius;
len = 2*r+1;
% kernels = zeros(len, len, 8, 'double');

% Box Filter
if strcmp(type, 'box')
    k = ones(len, 1);  % separable kernel 
    k_L = k;
    k_L(r+2: end) = 0;
    k_R = flipud(k_L);
    kernels0 = cat(3, k   * k_L', k   * k_R', k_L * k'  , k_R * k'  , ...
                     k_L * k_L', k_L * k_R', k_R * k_L', k_R * k_R');

% Mean Filter
elseif strcmp(type, 'mean')
    k = ones(len, 1) / len;  % separable kernel 
    k_L = k;
    k_L(r+2: end) = 0;
    k_L = k_L / sum(k_L);  % half kernel
    k_R = flipud(k_L);
    kernels0 = cat(3, k   * k_L', k   * k_R', k_L * k'  , k_R * k'  , ...
                     k_L * k_L', k_L * k_R', k_R * k_L', k_R * k_R');

% Median Filter (give valid elem 1, and not valid elem NaN)
elseif strcmp(type, 'median')
    k = ones(len, 1);  % separable kernel, all elem set to 1
    k_L = k;
    k_L(r+2: end) = NaN;  % half kernel
    k_R = flipud(k_L);
    k1 = k;
    k1(r+1: end) = NaN;
    k2 = k;
    k2(1: r) = NaN;
    k2(r+2: end) = NaN;
    k3 = flipud(k1);
    kernels0 = cat(3, k   * k_L', k   * k_R', k_L * k'  , k_R * k'  , ...
                     k_L * k_L', k_L * k_R', k_R * k_L', k_R * k_R'  , ...
                     k * k', k   * k2' , k2  * k'  ,  [k1, k2, k3] , [k3, k2, k1] );
    

end
