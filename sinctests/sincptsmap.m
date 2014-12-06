function pass = sincptsmap
% build two sincfuns and check that the cosine evaluates satisfactorily

f = @(x) exp(x); ff = sincfun(f);   % functions and sincfuns
[xx,ss] = sincpts(ff);
a = ff.domain(1); b = ff.domain(2);
eval(['phi_inv=' sincfunpref('invmap') ';'])

% check that sincpoints map to equispaced points in s-plane
pass = norm(xx - phi_inv(ss),'inf') == 0 ;

end