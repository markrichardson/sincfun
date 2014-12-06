function pass = largesmin
% check that the barycentric formula is working properly 
% even when the sdomain is large and asymmetric. 
% (problems could be to do with the weight function)

dmn = sincfunpref('domain');        % get default domain
xx = linspace(dmn(1),dmn(2),12)';   % build vector of test nodes
xx = xx(1:end-2); yy = xx/1e14;

f = @(x) x.^0.1; ff = sincfun(f);   % function requiring large smin

test_tol = 5*sincfunpref('tol');
pass(1) = max(abs(f(xx) - ff(xx))) < test_tol;
pass(1) = max(abs(f(yy) - ff(yy))) < test_tol;
