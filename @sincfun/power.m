function sfout = power(ff,exponent)
% POWER : defines raising sincfuns to the power of some exponent
% Mark Richardson 24/3/10

sfout = comp(ff,@(x) x.^exponent);
     
end

% 
% % separate case for linear sincfun
% if isempty(ff)
%     sfout = sincfun(@(x) feval(ff,x).^exponent,ff.domain);
%     return
% end
% 
% % estimate new sdomain
% compvals = abs(sincvals(ff)).^exponent;  % absolute values of sincvals
% tol = sincfunpref('tol')/6;         % set tol
% mid13 = round(length(ff)/3);        % approximately divide into thirds
% mid23 = round(2*length(ff)/3);
% firstloc = find(compvals(1:mid13) < tol,1,'last');
% lastloc = find(compvals(mid23:end) < tol,1,'first') + mid23;
% 
% [xx,ss] = sincpts(ff);              % get sincpts
% 
% if isempty(firstloc) || isempty(lastloc)
%     stretch = 1.01;
%     smin = ff.sdomain(1)*stretch;
%     smax = ff.sdomain(2)*stretch; 
% else
%     % sdomain has shrunk on both sides (eg ff.^2)
%     smin = ss(firstloc);
%     smax = ss(lastloc);
% 
% end
% 
% sfout = sincfun(@(x) feval(ff,x).^exponent,'sdomain',[smin,smax],...
%                     'endvals',ff.endvals.^exponent,ff.domain);
% 
% % sfout = sincfun(@(x) feval(ff,x).^exponent,ff.domain);