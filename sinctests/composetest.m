function pass = composetest
% build two sincfuns and check that the cosine evaluates satisfactorily

dmn = sincfunpref('domain');        % get default domain
xx = linspace(dmn(1),dmn(2),12)';   % build vector of test nodes

f = @(x) exp(x); ff = sincfun(f);   % functions and sincfuns
g = @(x) sqrt(x); gg = sincfun(g);
t = @(x) f(g(x));
tt = ff(gg);

x = sincfun('x'); p = x(x);

test_tol = 5*sincfunpref('tol');
pass(1) = max(abs(t(xx) - tt(xx))) < test_tol;
pass(2) = max(abs(p(xx)-x(xx)))==0;