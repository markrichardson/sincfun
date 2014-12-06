function pass = plustest
% build three sincfuns and check that they evaluate satisfactorily

dmn = sincfunpref('domain');            % get default domain
xx = linspace(dmn(1),dmn(2),12)';       % build vector of test nodes

f = @(x) exp(x); ff = sincfun(f);       % functions and sincfuns
g = @(x) sqrt(x); gg = sincfun(g);

test_tol = 3*sincfunpref('tol');

t = @(x) f(x) + g(x); tt1 = ff + gg;    % add functions and sincfuns

pass(1) = max(abs(t(xx) - tt1(xx))) < test_tol;
