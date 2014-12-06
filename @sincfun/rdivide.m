function fout = rdivide(ff,gg)
% RDIVIDE defines division: sincfun/sincfun or sincfun/double
% Mark Richardson 24/3/10

if isa(gg,'sincfun')
    if ~xdmncheck(ff,gg)
        error('x-domains need to be the same')
    end 
    if ~isempty(roots(gg))
       error('denominator has zeros in its interval of definition') 
    end
    fout = comp(ff,@(x,y) rdivide(x,y),gg);
else
    fout = ff/gg;
end
