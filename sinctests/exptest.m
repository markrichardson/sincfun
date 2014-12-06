function pass = exptest
% build two sincfuns and check that the cosine evaluates satisfactorily

dmn = sincfunpref('domain');        % get default domain
xx = linspace(dmn(1),dmn(2),12)';   % build vector of test nodes

f = @(x) sin(x); ff = sincfun(f);   % functions and sincfuns
g = @(x) sqrt(x); gg = sincfun(g);

s = @(x) exp(f(x)); ss = exp(ff);
t = @(x) exp(g(x)); tt = exp(gg);

test_tol = sincfunpref('tol');

pass(1) = max(abs(s(xx) - ss(xx))) < 5*test_tol;
pass(2) = max(abs(t(xx) - tt(xx))) < 5*test_tol;
