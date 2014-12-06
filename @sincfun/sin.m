function sfout = sin(sf)
% SIN : defines sine function for sincfuns
% Mark Richardson 24/3/10

% sfout = sincfun(@(x) sin(feval(sf,x)),sf.domain);
      
sfout = comp(sf,@(x) sin(x));

end