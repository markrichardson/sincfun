function pass = logtest
% build two sincfuns and check that the log evaluates satisfactorily

dmn = sincfunpref('domain');        % get default domain
xx = linspace(dmn(1),dmn(2),12)';   % build vector of test nodes

f = @(x) exp(x); ff = sincfun(f);   % functions and sincfuns
g = @(x) sqrt(x)+1; gg = sincfun(g);

s = @(x) log(f(x)); ss = log(ff);
t = @(x) log(g(x)); tt = log(gg);

test_tol = 5*sincfunpref('tol');

pass(1) = isempty(ss.vals);
pass(2) = max(abs(s(xx) - ss(xx))) < test_tol;
pass(3) = max(abs(t(xx) - tt(xx))) < test_tol;