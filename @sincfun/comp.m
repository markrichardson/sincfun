function sfout = comp(ff,op,gg)
% function either composes the sincfun 'ff' with the operator 'op' or 
% the sincfuns 'ff' and 'gg' with op so that the following is returned:
% 
% comp(ff,op) ->     sfout = op(ff);
% comp(ff,op,gg) ->  sfout = op(ff,gg);
%
% the function returns a sincfun

if nargin <3 
    % separate case for linear sincfun
    if isempty(ff.vals)
        sfout = sincfun(@(x) op(feval(ff,x)),ff.domain);
        return
    end
    
    % temporary fix - use same sdomain
    sdomain = ff.sdomain;
    sfout = sincfun(@(x) op(feval(ff,x)),'sdomain',sdomain,...
                        'endvals',op(ff.endvals),ff.domain);
else

    if ~xdmncheck(ff,gg)
        error('require x-domains to be identical for binary operations')
    end
    % temporary fix: use union of sdomains
    smin = min(ff.sdomain(1),gg.sdomain(1));
    smax = max(ff.sdomain(2),gg.sdomain(2));
    sfout = sincfun(@(x) op(feval(ff,x),feval(gg,x)),'sdomain',...
               [smin,smax],'endvals',op(ff.endvals,gg.endvals),ff.domain);
end

end

    


%     sdomain = get_sdomain(ff,op)
%     sdomain = comp_get_sdomain(ff,op)

% function sdomain = get_sdomain(ff,op)
%     
%     % compute finite differences of op(vals)
%     d_absvals = abs(diff(op(sincvals(ff))));
%    
%     pp = find(d_absvals>sincfunpref('tol'),1,'first');
%     qq = find(d_absvals>sincfunpref('tol'),1,'last');
%     
%     if ~isempty(pp)
%         smin = ff.spts(pp);
%         % check for too small a reduction
%         if 2*abs(smin) < abs(ff.sdomain(1))
%             smin = ff.sdomain(1);
%         end
%     else
%         smin = ff.sdomain(1);
%     end
%     
%     if ~isempty(qq)
%         smax = ff.spts(qq);
%         % check for too small a reduction
%         if abs(smax) < 3*abs(ff.sdomain(2))/2
%             smax = ff.sdomain(2);
%         end
%     else
%         smax = ff.sdomain(2);
%     end
% %         ff.sdomain
%     sdomain = [smin smax];
% 
% end



% % separate case for linear sincfun
%     if isempty(ff)
%         sfout = sincfun(@(x) op(feval(ff,x)),ff.domain);
%         return
%     end
%     % estimate new sdomain
%     compvals = op(abs(sincvals(ff)));   % absolute values of sincvals
%     tol = sincfunpref('tol')/6;         % set tol
%     mid13 = round(length(ff)/3);        % approximately divide into thirds
%     mid23 = round(2*length(ff)/3);
%     firstloc = find(compvals(1:mid13) < tol,1,'last');
%     lastloc = find(compvals(mid23:end) < tol,1,'first') + mid23;
% 
%     [xx,ss] = sincpts(ff);              % get sincpts
% 
%     if isempty(firstloc) || isempty(lastloc)
%         stretch = 1.01;
%         smin = ff.sdomain(1)*stretch;
%         smax = ff.sdomain(2)*stretch; 
%     else
%         % sdomain has shrunk on both sides (eg ff.^2)
%         smin = ss(firstloc);
%         smax = ss(lastloc);
%     end
% sfout = sincfun(@(x) op(feval(ff,x)),'sdomain',[smin smax],...
%                     'endvals',op(ff.endvals),ff.domain);


    % separate case for linear sincfun
%     if isempty(ff)
%         sfout = sincfun(@(x) op(feval(ff,x)),ff.domain);
%         return
%     end
% 
%     % estimate new sdomain
%     compvals = op(abs(sincvals(ff)),abs(sincvals(gg)));   % absolute values of sincvals
%     tol = sincfunpref('tol')/6;         % set tol
%     mid13 = round(length(ff)/3);        % approximately divide into thirds
%     mid23 = round(2*length(ff)/3);
%     firstloc = find(compvals(1:mid13) < tol,1,'last');
%     lastloc = find(compvals(mid23:end) < tol,1,'first') + mid23;
% 
%     [xx,ss] = sincpts(ff);              % get sincpts
% 
%     if isempty(firstloc) || isempty(lastloc)
%         stretch = 1.01;
%         smin = ff.sdomain(1)*stretch;
%         smax = ff.sdomain(2)*stretch; 
%     else
%         % sdomain has shrunk on both sides (eg ff.^2)
%         smin = ss(firstloc);
%         smax = ss(lastloc);
% 
%     end

