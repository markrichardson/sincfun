% ROOTS.M - Computes the roots of a sincfun using a 
% Chebyshev colleague matrix constructed in the s-plane. 
% Due to the O(N^3) nature of eigenvalue computation, 
% 'roots.m'uses recursive subdivision to ensure that the
% largest matrix worked with is 100x100.
%
% Example usage:
% 
% f = @(x) sqrt(x).*cos(6*pi*x);
% ff = sincfun(f);
% r = roots(ff)
% plot(ff), hold on,  plot(r,ff(r),'*r'), hold off

function x_roots = roots(ff)

% extract sincfun objects specifics
a = ff.domain(1); b = ff.domain(2);
eval(['phi_inv = ' sincfunpref('invmap') ';']);

% set smin and smax
[dummy,ss]=sincpts(ff);

svals = sincvals(ff);

% if the function is linear do a quick computation to find the root
if isempty(svals)
    a = ff.domain(1); b = ff.domain(2);
    fa = ff.endvals(1); fb = ff.endvals(2);
    x_roots = a + fa*(b-a)/(fb-fa);
    return
end

% check preferences and apply the sign-change heuristic
if sincfunpref('rtsheur')
    % find the 'middle' of the curve, where the oscillations are
    % by looking for sign changes to locate first and last roots
    if svals(1) >= 0, ind1 = find(svals < 0,1,'first') -1;
        else ind1 = find( svals >= 0 ,1,'first') -1;        end
    if svals(end) >= 0, ind2 = find(svals < 0,1,'last') + 1;
        else ind2 = find( svals >= 0 ,1,'last') + 1;        end
    ss1 = ss(ind1); ss2 = ss(ind2);
else
    ss1 = ss(1); ss2 = ss(end);
end

% no sign change => no roots in interval (still may be endpoint roots)
if isempty(ss1) && isempty(ss2),
    x_roots = [];
    if abs(feval(ff,ff.domain(1))) < 5e-15 
        x_roots = [ff.domain(1) x_roots]; end
    if abs(feval(ff,ff.domain(2))) < 5e-15 
        x_roots = [x_roots ; ff.domain(2)]; end 
    return;
end

% splot(ff), hold on, plot(ss1,feval(ff,phi_inv(ss1)),'*r')
% plot(ss2,feval(ff,phi_inv(ss2)),'*r'), hold off

% initialise A, B and set the maximum size of colleague matrix 
A = ss1; B = ss2; npts = 100; 

% get chebyshev coefficients
chebcoeffs = get_chebcoeffs(ff,A,B,npts);

% obtain roots in the unit interval
t_roots = get_roots(chebcoeffs,ff,A,B,npts);

% map from t in [-1,1] to s in [A,B]
s_roots = (A*(1-t_roots)+B*(1+t_roots))/2; 

% map from s in [A,B] to x in [a,b]
x_roots = phi_inv(s_roots);

% check to see if there are roots at the interval endpoints
if abs(feval(ff,ff.domain(1))) < 5e-14*ff.scl 
    x_roots = [ff.domain(1) ; x_roots]; end
if abs(feval(ff,ff.domain(2))) < 5e-14*ff.scl 
    x_roots = [x_roots ; ff.domain(2)]; end

end

function t_roots = get_roots(chebcoeffs,ff,A,B,npts)
% recursively computes the roots of a sincfun on the unit interval. 

% how many of the chebcoeffs are smaller than 1e-15?
qq = sum( abs(chebcoeffs) < 1e-15*ff.scl );

% watch out for functions that have alternating zero coefficients 
alt_tol = 5e-14;
if abs(chebcoeffs(1)) < alt_tol && abs(chebcoeffs(3)) < alt_tol
    largeterms = 2*(length(chebcoeffs) - qq);
    smallterms = length(chebcoeffs) - largeterms;
elseif abs(chebcoeffs(2)) < alt_tol && abs(chebcoeffs(4)) < alt_tol 
    largeterms = 2*(length(chebcoeffs) - qq);
    smallterms = length(chebcoeffs) - largeterms;
else
    smallterms = qq;
end

if smallterms > 2 

    % chop off the small coefficients and leave one or two extras 
    trunc_coeffs = chebcoeffs(1:end-smallterms+3);
    
    % colleague matrix as in chapter 18 of ATAP
    C1 = toeplitz([0 0.5 zeros(1,length(trunc_coeffs)-3)]); C1(1,2)=1;
    C2 = zeros(size(C1)); C2(end,:) = trunc_coeffs(1:end-1);
    
    % make sure end value is not exactly zero as need to compute 1/a_n
%     trunc_coeffs(trunc_coeffs == 0) = ff.scl*eps/10;
    if trunc_coeffs(end) == 0, trunc_coeffs(end) = ff.scl*eps/10; end
    
    C = C1 - 1/(2*trunc_coeffs(end))*C2;

    % compute the eigenvalues
    eigvals = eig(C);                   
    
    % extract the real roots 
    real_roots = eigvals(abs(imag(eigvals))< 1e-14*ff.scl); 

    % only keep roots in the [-1,1] interval
    t_roots = sort(real_roots(abs(real_roots)<1+5e-15));
    
else
    
    % define an arbitrary dividing point in [-1,1]
    cc = -0.004849834917525; 
    % rescale this point to the interval [A,B]
    midAB = (A*(1-cc)+B*(1+cc))/2;
    
    % build 'chebfuns' on the divided intervals
    cheb1 = get_chebcoeffs(ff,A,midAB,npts);
    cheb2 = get_chebcoeffs(ff,midAB,B,npts);
    
    % recursively obtain the roots on the unit interval
    rts1 = get_roots(cheb1,ff,A,midAB,npts);
    rts2 = get_roots(cheb2,ff,midAB,B,npts);
    
    % rescale rts1 to [-1 cc] and rts2 to [cc 1]
    t_rts1 = (-(1-rts1)+cc*(1+rts1))/2;
    t_rts2 = (cc*(1-rts2)+(1+rts2))/2;
    
    % output roots in the [-1 1] interval
    t_roots = [t_rts1 ; t_rts2];

end

end

function chebcoeffs = get_chebcoeffs(ff,A,B,npts)
% get 'npts' chebyshev coefficients for ff in unit interval, mapped from 
% the s-interval [A,B]

a = ff.domain(1); b = ff.domain(2);
eval(['phi_inv =' sincfunpref('invmap') ';']);

tcheb = chebpts(npts);              % set chebpts in the t interval [-1 1]
scheb = (A*(1-tcheb)+B*(1+tcheb))/2;% map to the s-domain
xcheb = phi_inv(scheb);             % map to the x domain
xcheb_vals = feval(ff,xcheb);       % evaluate sincfun at the mapped points
vals = flipud(xcheb_vals);          
vals2 = [vals;flipud(vals(2:end-1))]; % spread around unit circle 
transVals = real(fft(vals2));       % take fft 
coeffs = flipud(transVals(1:length(vals)))/(length(vals)-1);
coeffs(1) = coeffs(1)/2; 
coeffs(end) = coeffs(end)/2;        % chebyshev coefficients a_n, ... ,a_0
chebcoeffs = flipud(coeffs);        % chebyshev coefficients a_0, ... ,a_n

end