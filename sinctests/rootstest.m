function pass = rootstest
% build three sincfuns and check that they integrate satisfactorily

f = @(x) sin(2*pi*x); ff = sincfun(f);   % functions and sincfuns
g = @(x) sqrt(x).*cos(10*pi*x); gg = sincfun(g);   % recursive example

rts_f = (0:0.5:1)';
rts_g = [0;(0.05:0.1:0.95)'];

test_tol = 10*sincfunpref('tol');

pass(1)=all(abs(roots(ff)-rts_f)<test_tol);
pass(2)=all(abs(roots(gg)-rts_g)<test_tol);
