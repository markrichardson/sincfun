function pass = opsnrzero
% checks that the construction process is working properly for 
% sincfuns that are close to zero at the interval endpoints

ff = sincfun('exp(x)-1');
gg = sincfun('exp(x)-exp(1)');

pass(1) = length(cos(ff.^2)) < 450;
pass(2) = length(sin(gg.^2)) < 450;
