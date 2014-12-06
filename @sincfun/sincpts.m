function [sincpts,equispaced] = sincpts(sf)
% SINCPTS returns the sincpoints of a sincfun on the interval (a,b) and 
% equispaced nodes on the truncated infinite interval. The default call
% a = sincfun(ff) returns the first quantity whlist [a,b] = sincfun(ff)
% returns two vectors.
M = sf.numterms(1); N = sf.numterms(2); h = sf.h;
% compute equispaced nodes on the infinite interval 
equispaced = h*(-M:N)';
% define domain and inverse map 
a = sf.domain(1); b = sf.domain(2);
eval(['phi_inv=' sincfunpref('invmap') ';'])
sincpts = phi_inv(equispaced);
end