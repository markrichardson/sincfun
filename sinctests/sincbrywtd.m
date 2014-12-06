function pass = sincbrywtd
% check sincbary4 is working properly

dmn = sincfunpref('domain');        % get default domain
xx = linspace(dmn(1),dmn(2),12)';   % build vector of test nodes

f = @(x) x.^0.5; ff = sincfun(f);   % functions and logcfuns

test_tol = 5*sincfunpref('tol');
vals = sinc_bary_weighted(ff,xx);

pass(1) = max(abs(f(xx) - vals)) < test_tol;

end

% f = @(x) x.^0.2; ff = sincfun(f);   % functions and logcfuns
% 
% test_tol = 5*sincfunpref('tol');
% vals = sinc_bary_weighted(ff,xx);
% 
% pass(1) = max(abs(f(xx) - vals)) < test_tol;