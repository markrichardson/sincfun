function sfout = mrdivide(sf1,sf2)
% SFOUT - Defines division of a sincfun by a scalar
% Mark Richardson 24/3/10

if isa(sf1,'double')
   error('can''t divide a scalar by a sincfun')
end
    
sfout = sf1;
sfout.vals = sf1.vals/sf2;
sfout.endvals = sf1.endvals/sf2;
sfout.scl = sf1.scl/sf2;

