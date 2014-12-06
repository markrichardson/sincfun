function sfout = mtimes(sf1,sf2)
% SFOUT - Defines multiplicaton of sincfuns by scalars
% Mark Richardson 24/3/10

% ensure that sf1 is the sincfun and sf2 is the scalar
if isa(sf1,'double')
   temp = sf2;
   sf2 = sf1;
   sf1 = temp;
end
    
sfout = sf1;
sfout.vals = sf2*sf1.vals;
sfout.endvals = sf2*sf1.endvals;
sfout.scl = sf1.scl*sf2;

