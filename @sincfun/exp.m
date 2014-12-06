function sfout = exp(sf)
% EXP : defines exponential function for sincfuns
% Mark Richardson 24/3/10

% sfout = sincfun(@(x) exp(feval(sf,x)),sf.domain);
      
sfout = comp(sf,@(x) exp(x));

end

