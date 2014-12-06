function sfout = uminus(sf)
% UPLUS - unary plus for sincfuns
% Mark Richardson 24/3/10
sfout = sf;
sfout.vals = -1*sf.vals;
sfout.endvals = -sf.endvals;
end