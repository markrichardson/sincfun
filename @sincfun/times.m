function sfout = times(sf1,sf2)
% TIMES defines multiplication:sincfun x sincfun or sincfun x double
% Mark Richardson 24/3/10

% deal with multiplying sincfuns by doubles 
if isa(sf1,'double') || isa(sf2,'double')
    sfout = sf1*sf2;
    return
end

sfout = comp(sf1,@(x,y) times(x,y),sf2);

end

% % check domains are the same
% if sum(sf1.domain-sf2.domain)~=0 
%     error('sincfuns defined on different domains cannot be multplied')
% end

% send @(x) sf1(x).*sf2(x) to the constructor
% a=sf1.domain(1); b=sf1.domain(2);
% F = @(x) feval(sf1,x).*feval(sf2,x);
% sfout = sincfun(F,[a b]);