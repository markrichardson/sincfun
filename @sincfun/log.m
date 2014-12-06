function sfout = log(sf)
% COS : defines natural log function for sincfuns
% Mark Richardson 24/3/10

a = sf.domain(1); b = sf.domain(2);
if ~isempty((roots(sf)==0))
    error('function diverges to infinity -- can''t yet represent in sincfun')
end
% 
% F = @(x) log(feval(sf,x));
% sfout = sincfun(F,[a b]);
      
sfout = comp(sf,@(x) log(x));

end
