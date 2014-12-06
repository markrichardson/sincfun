function pass = subsreftest
% check each of the subsref commands
f = @(x) exp(x); ff = sincfun(f); pass = ones(1,8);   
try ff(0.5);        catch,      pass(1) = 0; end
try ff.domain;      catch,      pass(2) = 0; end
try ff.sdomain;     catch,      pass(3) = 0; end
try ff.numterms;    catch,      pass(4) = 0; end
try ff.h;           catch,      pass(5) = 0; end
try ff.vals;        catch,      pass(6) = 0; end
try ff.endvals;     catch,      pass(7) = 0; end
try ff.scl;         catch,      pass(8) = 0; end

