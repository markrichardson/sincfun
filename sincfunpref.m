function varargout = sincfunpref(varargin)
% SINCFUNPREF - sets the sincfun preferences structure
% 
% SINCFUNPREF - intialises sincfunpref and returns current status
% SINCFUNPREF('tol',1e-14) - sets sincfun tolerance to 1e-14
% SINCFUNPREF('domain',[-2 3]) - sets sincfun domain to [-2 3]
% SINCFUNPREF('map',@(x) (x-a)./(b-x)) - changes x -> s map
% SINCFUNPREF('invmap',@(s) (b*s-a)./(1+s)) - changes s -> x map
% SINCFUNPREF('showcon',1) - constructor shows the Fourier coeffs decaying
% SINCFUNPREF(previousPrefsStruct) - sets prefs to a previous setting

persistent prefs        % remembered by this function

% if nargin is 0 or 1, then we either need to initialise 
% sincfunpref, or a user wants to see one or all of the settings
if nargin == 0 
    if isempty(prefs)
       % initialise if not already set
       prefs = default_prefs; 
    end
    varargout = {prefs};
    return
elseif nargin == 1
    if isstruct(varargin{1})
        % check that if a struct is passed in, it has the 
        % same fields as a sincfun prefs struct (TO DO!!)
        prefs = varargin{1};
        varargout = {prefs};
    elseif strcmpi(varargin{1},'reset')
        % set to default settings if 'default' is passed
        prefs = default_prefs;
        varargout = {prefs};
    else
        varargout{1} = prefs.(varargin{1});
    end
    return
end

% if nargin > 1, then the user wants to change a setting
% first make sure that prefs has been initialised
if isempty(prefs) 
    prefs = default_prefs; 
end

k = 1;                            % cycle thorugh {varargin} array
while k <= length(varargin)       % change prefs structure accordingly
   if strcmpi('tol',varargin{k})
       if ~isnumeric(varargin{k+1})
           error('require a numerical value for ''tol'' preference ')
       end
       prefs.tol = varargin{k+1};
       k = k + 2;
   elseif strcmpi('domain',varargin{k})
       if sum(size(varargin{k+1})==[1 2])~=2
           error('require a vector [a b] for ''domain'' preference ')
       end
       prefs.domain = varargin{k+1};
       k = k + 2;
   elseif strcmpi('map',varargin{k})
       if ~ischar(varargin{k+1}) 
           error('require anonymous function as a string')
       end
       prefs.map = varargin{k+1};
       k = k + 2;
   elseif strcmpi('invmap',varargin{k})
       if ~ischar(varargin{k+1}) 
           error('require anonymous function as a string')
       end
       prefs.invmap = varargin{k+1};
       k = k + 2;    
   elseif strcmpi('showcon',varargin{k})
       if varargin{k+1}~=0 && varargin{k+1}~=1 && ~ischar(varargin{k+1}) 
           error('require 1/0/true/false for ''showcon'' preference ')
       end
       prefs.showcon = varargin{k+1};
       k = k + 2;
   elseif strcmpi('rtsheur',varargin{k})
       if varargin{k+1}~=0 && varargin{k+1}~=1 && ~ischar(varargin{k+1}) 
           error('require 1/0/true/false for ''showcon'' preference ')
       end
       prefs.rtsheur = varargin{k+1};
       k = k + 2;
   else
       error('unrecognised sincfunpref')
   end
end

varargout = {prefs};

end


function varargout = default_prefs
% DEFAULT_PREFS.M
% returns structure of default preferences for sincfun class
%        tol - interpolant tolerance
%     domain - (open) interval of definition (a,b)
%        map - maps x in (a,b) -> z in (-inf,inf)
%     invmap - maps z in (-inf,inf) -> x in (a,b)
%    showcon - show the fourier coefficients decay
%    rtsheur - switches the roots sign change heurstic on (default) and off
options =   { 'tol',   'domain' ,       'map',               'invmap'   , 'showcon', 'rtsheur'};
factoryvals = {eps,     [0 1] ,'@(x) log((x-a)./(b-x))','@(s) (a+b*exp(s))./(1+exp(s))',false,false};
for k = 1:length(factoryvals)
    varargout.(options{k}) = factoryvals{k};
end
varargout = {varargout};
end


