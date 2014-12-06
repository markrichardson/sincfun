function pass = dividetest

f = @(x) cos(x); ff = sincfun(f);
g = @(x) sqrt(x)+1; gg = sincfun(g);

t = @(x) f(x)./g(x); tt = ff./gg;
xx = linspace(ff.domain(1),ff.domain(2),30)'; test_tol = 2*eps;

pass = max(abs(t(xx) - tt(xx))) < test_tol;


