function pass = nonadapt
% check each of the potential input arguments can be succefully entered
f = @(x) exp(x); pass = ones(1,5);   
try sincfun(f,300);                  catch, pass(1) = 0; end
try sincfun(f,[-2 2]);               catch, pass(2) = 0; end
try sincfun(f,'sdomain',[-40 40]);   catch, pass(3) = 0; end
try sincfun(f,'endvals',[1 exp(1)]); catch, pass(4) = 0; end
try sincfun(f,'tol',1e-10);          catch, pass(5) = 0; end

