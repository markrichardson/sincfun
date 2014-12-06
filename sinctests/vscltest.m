function pass = vscltest
% build a sincfun and check that it is scale invariant

ff = sincfun('exp(x)');
ffbig = sincfun('1e200*exp(x)');
ffsmall = sincfun('1e-200*exp(x)');

gg = sincfun('sqrt(x)');
ggbig = sincfun('1e200*sqrt(x)');
ggsmall = sincfun('1e-200*sqrt(x)');

pass(1) = abs(length(ff)-length(ffbig)) < 3;
pass(2) = abs(length(ff)-length(ffsmall)) < 3;

pass(3) = abs(length(gg)-length(ggbig)) < 3;
pass(4) = abs(length(gg)-length(ggsmall)) < 3;