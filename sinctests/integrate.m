function pass = integrate
% build three sincfuns and check that they integrate satisfactorily

f = @(x) exp(x); ff = sincfun(f);   % functions and sincfuns
g = @(x) sqrt(x); gg = sincfun(g);
h = @(x) cos(3*pi*x/2); hh = sincfun(h);

test_tol = 2*sincfunpref('tol');

pass(1) = abs(sum(ff)-exp(1)+exp(0)) < test_tol;
pass(2) = abs(sum(gg)-2/3) < test_tol;
pass(3) = abs(sum(hh)-sin(3*pi/2)*2/(3*pi)) < test_tol;