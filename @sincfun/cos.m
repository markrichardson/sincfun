function sfout = cos(sf)
% COS : defines cosine function for sincfuns
% Mark Richardson 24/3/10

% sfout = sincfun(@(x) cos(feval(sf,x)),sf.domain,'endvals',cos(sf.endvals),sf.domain);
     
sfout = comp(sf,@(x) cos(x));

end


