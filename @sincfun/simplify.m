function sfout = simplify(sf)
% simplifies a sincfun by truncating unneeded terms from vals field

% intialise output sincfun
sfout = sf;

if isempty(sf.vals), return, end

% take absolute value of sf.vals*sf.scl
absvals = abs(sf.vals); 

% count the number of small terms at each end
indL = 0; indR = 0; tol = eps*sf.scl;
while absvals(indL+1) < tol
    indL = indL + 1;
end

while absvals(end-indR) < tol
    indR = indR + 1;
end

% if no terms have been chopped off don't bother with the work below 
if indL == 0 && indR ==0
    sfout = sf; return
end

% new numterms entries
m_new = sf.numterms(1) - indL;
n_new = sf.numterms(2) - indR;

h = sf.h;
% update fields
sfout.sdomain = h*[-m_new n_new];
sfout.numterms = [m_new n_new];
sfout.spts = h*(-m_new:n_new)';
sfout.vals = sf.vals(indL+1:end-indR);

% get baryweights
[weights,alpha,gamma] = get_baryweights(sfout.sdomain,sfout.spts);
sfout.weights = weights;
sfout.mobius = [alpha,gamma];

end

