function norm = norm(sf)
% continuous 2-norm of a sincfun
norm = sum(sf.^2).^0.5;

end







% % 2 norm of a sincfun
% 
%    rts = roots(sf);
%    tol = 5*eps;
%    % are they the same as the endpoints?
%    if ~isempty(rts)
%        if abs(rts(1)-sf.domain(1)) < tol
%            rts = rts(2:end);
%        end
%        if abs(rts(end)-sf.domain(2)) < tol
%            rts = rts(1:end-1);
%        end
%    end   
%      
%     switch isempty(rts)
%         % no roots in interval, compute square of function, 
%         % integrate and square root the result
%         case true    
%             norm = sqrt(sum(sf.^2));
%   
%         case false
%             
%             rts = rts(:);
%             rts = [sf.domain(1) ; rts ; sf.domain(2)];
%             
%             temp = 0;
%             
%             for k = 1:length(rts)-1
%                 sf_temp = sincfun(@(x) feval(sf,x).^2,[rts(k) rts(k+1)]);
%                 temp = temp + sum(sf_temp);
%             end
%             norm = sqrt(temp);
%     end


 
