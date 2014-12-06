function sfout = plus(sf1,sf2)
% PLUS defines addition of sincfun + sincfun or sincfun + double
% Mark Richardson 24/3/10

% deal with adding doubles to a sincfun
if isa(sf1,'double') || isa(sf2,'double')
    if isa(sf1,'sincfun')
        sfout = sf1; sfout.scl = sf1.scl+sf2;
        sfout.endvals = sf1.endvals + sf2;
    else
        sfout=sf2; sfout.scl = sf2.scl+sf1;
        sfout.endvals = sf2.endvals + sf1;
    end
    return
end

% check domains are the same
if sum(sf1.domain-sf2.domain)~=0 
    error('sincfuns defined on different domains cannot be added')
end

sfout = sf1;

a = sf1.domain(1); b = sf1.domain(2); 
fa = sf1.endvals(1) + sf2.endvals(1);
fb = sf1.endvals(2) + sf2.endvals(2);

%if sincfuns are of the same dimensions, just add the vals fields
if sum(sf1.numterms == sf2.numterms) == 2
    sfout.vals = sf1.vals + sf2.vals; 
    sfout.endvals = [fa fb];
    sfout.scl = sf1.scl+sf2.scl;
    return
end

% else, send:  @(x) sf1(x)+sf2(x) to the constructor
% F = @(x) feval(sf1,x) + feval(sf2,x);
% sfout = sincfun(F,[a b]);

% F = @(x) feval(sf1,x) + feval(sf2,x);
% sfout = sincfun(F,[a b],'endvals',[F(a) F(b)]);

sfout = comp(sf1,@(x,y) plus(x,y),sf2);

end

