function fout = sincfun(g,varargin) 
% SINCFUN.M - constructor of sincfun objects
% fields: 'domain','numterms','h','vals','endvals','sdomain','scl' 

sf = struct([]); 

if nargin == 0                  % return empty sincfun
    sf(1).domain = [];          sf(1).sdomain = [];         
    sf(1).numterms = [];        sf(1).h = [];               
    sf(1).spts = [];            sf(1).vals = [];            
    sf(1).endvals = [];         sf(1).scl = [];             
    sf(1).weights = [];         sf(1).mobius = [];          
    fout = class(sf,'sincfun'); return
end
    
% send to internally defined function to define anon functions
g = setAnonFunc(g);

inputargs = varargin;
[totalnumtermsFlag,specs,totalnumterms] = optional_inputs(inputargs);

% set default domain field
if isfield(specs,'domain')
    sf(1).domain = specs.domain;
else
    sf(1).domain = sincfunpref('domain');
end

% get endpoint function values
a = sf.domain(1); b = sf.domain(2);

% user specified 'endvals' - function values at interval endpoints
if isfield(specs,'endvals')
    ga = specs.endvals(1); gb = specs.endvals(2);
else
    [ga,gb] = get_end_vals(g,a,b);
end
endvals = [ga gb];

% subtract linear function to give function approximated by sinc functions
f = @(x) feval(g,x) - (gb-ga)./(b-a).*(x-a) - ga;

% user specified 'sdomain' - extreme values in the s-plane
if isfield(specs,'sdomain')
    sdomain = specs.sdomain;
else
    sdomain = get_sdomain(f,specs);       
end

% adaptively obtain coefficients if user does not specify nPts or lengths
if totalnumtermsFlag
    [numterms,h,spts,vals,scl] = nonadaptive(f,totalnumterms,endvals,sdomain,specs);
else
    [numterms,h,spts,vals,scl] = adaptive(f,endvals,sdomain,specs); 
end

% get the barycentric weights and Mobius transform parameters
if ~isempty(vals)
    [weights,alpha,gamma] = get_baryweights(sdomain,spts);
else
    weights = []; alpha = []; gamma = [];
end

% set other fields
% sf(1).sdomain = sdomain;
sf(1).sdomain = h*[-numterms(1) numterms(2)];            
sf(1).numterms = numterms;  
sf(1).h = h;                        sf(1).spts = spts;       
sf(1).vals = vals;                  sf(1).endvals = endvals; 
sf(1).scl = scl;                    sf(1).weights = weights;  
sf(1).mobius = [alpha,gamma];

fout = class(sf,'sincfun');

if length(vals) > 2 && ~totalnumtermsFlag
        fout = simplify(fout); end

end

%--------------------------------------------------------------------------
function gout = setAnonFunc(g)
% Deals with the input argument f. If f is a string it converts it into an
% anonymous function. If it is a constant, it sets this to the
% corresponding anonymous function.
if isa(g,'char'), eval(['g=@(x) ' g ';']), end
if isnumeric(g), g = @(x) 0.*x+ g ;  end
% check for constant function
if isa(g,'function_handle')
    t = functions(g); str = t.function;
    str2 = str(strfind(str,')')+1:end); % look for bit after @(x) ...
    if sum(isletter(str2)) == 0, g1 = eval(str2); g = @(x) 0.*x + g1; end
    gout = g;
end
if isa(g,'sincfun'), gout = g; end
end

%--------------------------------------------------------------------------
function [totalnumtermsFlag,specs,totalnumterms] = optional_inputs(inputargs)

totalnumtermsFlag = false; totalnumterms = [0 0];

specs = sincfunpref;             % call sincfunpref function (in private)
k = 1;                           % cycle thorugh {varargin} array
while k <= length(inputargs)     % change specs structure accordingly
   if ischar(inputargs{k})
       if strcmpi('tol',inputargs{k})
           specs.tol = inputargs{k+1};
           k = k + 2;
       % add new field to specs struct if 'sdomain' or 'endvals' are found
       elseif strcmpi('sdomain',inputargs{k})
           specs.sdomain = inputargs{k+1};
           k = k + 2;
       elseif strcmpi('endvals',inputargs{k})
           specs.endvals = inputargs{k+1};
           k = k + 2;
       % pass 'showcon' to display fourier coefficients in the constructor
       elseif strcmpi('showcon',inputargs{k})
           specs.showcon = true;
           k = k + 1;
       else
           error('unrecognised input parameter')
       end
   else 
       % domain [a b]
       if isa(inputargs{k},'double') && sum(size(inputargs{k})==[1 2])==2
           specs.domain = inputargs{k};
           k = k + 1;
       % totalnumterms (integer)
       elseif isa(inputargs{k},'double') && sum(size(inputargs{k})==[1 1])==2
           totalnumterms = inputargs{k};
           totalnumtermsFlag = true;
           k = k + 1;  
       end
   end
end

end

%--------------------------------------------------------------------------
function [ga,gb] = get_end_vals(g,a,b)
ga = feval(g,a); gb = feval(g,b); 
if isinf(ga) || isnan(ga) || isinf(gb) || isnan(gb)
    ga = feval(g,a+eps(a)); gb = feval(g,b-eps(b));   
    if isinf(ga) || isinf(gb) || isnan(ga) || isnan(gb)
        error('sincfun requires the function to have defined and finite endpoint values')
    end
end

% % set small very small endpoint values to zero
% if abs(ga) <= 1.5*eps(a) || abs(ga) <= 1e-300, ga=0; end
% if abs(gb) <= 1.5*eps(b) || abs(gb) <= 1e-300, gb=0; end
end 

%--------------------------------------------------------------------------
function sdomain = get_sdomain(f,specs)
% % if f is a sincfun, don't bother with a search, just use the sdomain field
% if isa(f,'sincfun'), sdomain=f.sdomain; return, end

a = specs.domain(1); b = specs.domain(2); 
eval(['phi_inv=' specs.invmap ';'])
eval(['phi=' specs.map ';'])

% estimate scale
xx = linspace(specs.domain(1),specs.domain(2),12); x = xx(2:end-1);
scl = max(abs(feval(f,x))); tol = scl*specs.tol;

% what are xmax, xmin, zmax and zmin?

if a == 0
    s_infimum = phi(realmin);
else
    s_infimum = phi(a+eps(a));
end
s_supremum = phi(b-eps(b));

% do binary searches. First, smin;
A = s_infimum; B = 0; Mlast = 0; M = Inf;  
while abs(M-Mlast) > 1e-1
    Mlast = M; M = (A+B)/2;
%     abs(F(phi_inv(M)))
    if abs(f(phi_inv(M))) > tol, B = M; else A = M; end
end
smin = M;

% Next, smax;
A = 0; B = s_supremum; Mlast = 0; M = Inf;
while abs(M-Mlast) > 1e-1
    Mlast = M; M = (A+B)/2;
    if abs(f(phi_inv(M))) > tol, A = M; else B = M; end
end
smax = M;

sdomain = [smin smax];

end