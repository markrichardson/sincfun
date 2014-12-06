function [weights,alpha,gamma] = get_baryweights(sdomain,spts)
% obtain and store the barycentric weights in the sincfun structure
% speeds up barycentric evaluation. alpha and gamma are parameters 
% in the Mobius conformal map used in sinc_bary_weighted

% define weight function to have support in [smin,smax]
% use a mobius transform to map (-support,0,support) -> (smin,0,smax)
smin = sdomain(1); smax = sdomain(2);
% extend the support to just outside of the sdomain
support = 0.999*sqrt(abs(log(sincfunpref('tol'))));
% mobius transform parameters
alpha = smax/support*((smin+smax)/(smin-smax)+1);
gamma = (smin+smax)/(support*(smin-smax));
weights = exp(-(spts./(alpha-gamma*spts)).^2);
end