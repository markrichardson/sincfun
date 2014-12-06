
function fvals = sinc_bary_weighted(ff,xx)
% SINCFUN/SINC_BARY_WEIGHTED
% Weighted barycentric formula for sinc expansions. Modified from 
% [Berrut 1989] p709 and p712 by M. Richardson to include a Mobius 
% transform for the Gaussian weight function w(s).
%
% Mark Richarson 03/11/2010

a = ff.domain(1); b = ff.domain(2);         % get domain 
fa = ff.endvals(1); fb = ff.endvals(2);     % get endpoint function values

if ~isempty(ff.vals)
    eval(['phi =' sincfunpref('map') ';'])  % define mapping (a,b)->(-inf,inf)
    m = -ff.numterms(1); n = ff.numterms(2);% no. of terms in sum
    N = -m + n + 1;                         % set m  
    sk = ff.spts;                           % get equispaced sinc nodes
    gk = ff.vals;                           % sincfun values at sincpoints
    altOnes = ones(N,1).*(-1).^((m:n)');    % barycentric weights (-1)^j
    ss = phi(xx);                           % evaluation points in (-inf,inf) 
    wk = ff.weights;                        % extract barycentric weights
    alpha = ff.mobius(1); 
    gamma = ff.mobius(2);                   % Mobius transform parameters
    if length(xx) > length(ff)  
        numer = zeros(size(ss));            % initialise numerator 
        denom = numer;                      % initialise denominator
        exact = numer;                      % intitalise exact locations vec
        for i = 1:N                         % sum over the interpolation nodes              
            zdiff = ss-sk(i);                   
            temp = altOnes(i)./zdiff;
            numer = numer + temp*gk(i);
            denom = denom + temp*wk(i);  
            exact(zdiff==0) = 1;            % if evaluating at a sinc point, note location 
        end
        % evaluate Mobius-transformed weight function at the evaluation nodes
        fvals = exp(-(ss./(alpha-gamma*ss)).^2).*numer./denom;
        jnan = find(exact);
        if ~isempty(jnan)
            for k = 1:length(jnan)      
                fvals(jnan(k))=ff.vals(ss(jnan(k))==sk);
            end
        end       
    else
        % compute formula for each node if length(xx) <= length(ff)
        fvals = zeros(size(xx));
        for j = 1:length(ss)
            areTheSame = ss(j)==sk;
            if any(areTheSame)
                fvals(j) = gk(areTheSame);
            else
                sumterm = altOnes./(ss(j)-sk);
                sumterm = sumterm(:);
                fvals(j) = exp(-(ss(j)./(alpha-gamma*ss(j))).^2)*...
                                (sumterm'*gk)/(sumterm'*wk); 
            end
        end      
    end    
else
    fvals = 0;
end

% add on the linear term f(x) = g(x) + h(x)
fvals = fvals + (fb-fa)./(b-a).*(xx-a) + fa; 
fvals(xx==a) = fa; fvals(xx==b) = fb;

end
