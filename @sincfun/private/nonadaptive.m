function  [numterms,h,spts,vals,scl] = nonadaptive(F,totalnumterms,ends,sdomain,specs)
% NONADAPTIVE - divides up the truncated infinite s-line according to
% totalnumterms

a = specs.domain(1); b = specs.domain(2); 
fa = ends(1); fb = ends(2); 
eval(['phi_inv=' specs.invmap ';'])

smin = sdomain(1); smax = sdomain(2);
s_interval = smax-smin;
                            
% what is h?
h = s_interval/totalnumterms;
% work out the number of terms on the left
m = floor(abs(smin)/h); n = totalnumterms-m-1;
% work out s_k values
spts = (-m:n)'*h;
% compute sinc-points
xpts = phi_inv(spts);
% get sinc-vals
vals = F(xpts);

% estimate vertical scale using values at sincpoints
scl = max(abs(vals+(fb-fa)./(b-a).*(xpts-a) + fa));      

numterms = [m n];

end