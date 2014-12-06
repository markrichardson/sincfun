function pass = evaluate
% build three sincfuns and check that they evaluate satisfactorily

dmn = sincfunpref('domain');        % get default domain
xx = linspace(dmn(1),dmn(2),12)';   % build vector of test nodes

f = @(x) exp(x); ff = sincfun(f);   % functions and sincfuns
g = @(x) sqrt(x); gg = sincfun(g);

test_tol = 5*sincfunpref('tol');

pass(1) = max(abs(f(xx) - ff(xx))) < 5*test_tol;
pass(2) = max(abs(g(xx) - gg(xx))) < 5*test_tol;