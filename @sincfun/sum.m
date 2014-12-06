function val = sum(sf)
% SUM - computes an approximation to the definite integral over the domain
% of definition for a sincfun, using the quadrature rule given in Stenger's
% book p190 (4.2.37)
% Note: this will only work for the original Stenger mapping

% get domain and number of term in the expansion
a = sf.domain(1); b = sf.domain(2); h = sf.h;
fa = sf.endvals(1); fb = sf.endvals(2);
xk = sincpts(sf); gk = sf.vals;

if isempty(gk)
    val = 0;
else
    % quadrature rule
    val = h/(b-a)*gk'*((xk-a).*(b-xk));
end

% Add on the (integrated) linear correction 
val = val + 0.5*(fb-fa)*(b-a)+fa*(b-a);

end
