function yy = sincvals(sf)
% SINCPTS returns the values of sincfun at sincpoints. 
% This function is needed in order to add on the linear term. 

xx = sincpts(sf);     % get sincpts
 a = sf.domain(1);   b = sf.domain(2);
fa = sf.endvals(1); fb = sf.endvals(2);
yy = sf.vals + (fb-fa)./(b-a).*(xx-a) + fa;