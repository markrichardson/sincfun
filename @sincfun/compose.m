function sfout = compose(ff,gg)
% computes the composition of the sincfuns ff & gg: ff(gg)

% check (estimate using vals) that range of gg is in the domain of ff
if isempty(gg.vals)
    maxx = max(gg.endvals); minn = min(gg.endvals);
else
    maxx = max(sincvals(gg)); minn = min(sincvals(gg));
end

if maxx > ff.domain(2) || minn < ff.domain(1)
    error('ff(gg) requires range of gg to be in the domain of ff')
end

% set output structure
sfout = ff;

% set function to be evaluated
compfun = @(x) feval(ff,feval(gg,x));

% set interval [a,b]
a = sfout.domain(1); b = sfout.domain(2);

% user specified 'endvals' - function values at interval endpoints
compfuna = compfun(a); compfunb = compfun(b);
endvals = [compfuna compfunb];

% subtract linear function to give function approximated by sinc functions
f = @(x) compfun(x) - (compfunb-compfuna)./(b-a).*(x-a) - compfuna;

if ~isempty(ff.vals) || ~isempty(gg.vals) 
    % if either is not empty, use union of sdomain fields for new sdomin
    smin = min(ff.sdomain(1),gg.sdomain(1));
    smax = max(ff.sdomain(2),gg.sdomain(2));
    sdomain = [smin smax];
else
    sdomain = 1*[-1 1];
end

specs = sincfunpref; specs.domain = [a b];

% adaptive constructor step
[numterms,h,spts,vals,scl] = adaptive(f,endvals,sdomain,specs); 

% get the barycentric weights and Mobius transform parameters
[weights,alpha,gamma] = get_baryweights(sdomain,spts);
 
% set the output fields
sfout.sdomain = h*[-numterms(1) numterms(2)];            
sfout.numterms = numterms;          sfout.h = h;                        
sfout.spts = spts;                  sfout.vals = vals;                  
sfout.endvals = endvals;            sfout.scl = scl;                    
sfout.weights = weights;            sfout.mobius = [alpha,gamma];

% simplify the sincfun (remove unneeded terms)
sfout = simplify(sfout);

end