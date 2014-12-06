function [max_val,x_pos] = max(sf)

    % compute max by differentiating the sincfun and computing
    deriv = diff(sf);
    extrema = [sf.domain(1);roots(deriv);sf.domain(2)];
    extrema_vals = feval(sf,extrema);
    max_val = max(extrema_vals);
    x_pos = extrema(extrema_vals==max_val);

%     % if there are no roots, then the function is monotonic and the maximum
%     % values is at one of the endponts of the interval
%     if isempty(max_val)
%         max_val = max(sf.endvals);
%         if max_val == sf.endvals(1); x_pos = sf.domain(1);
%         else x_pos = sf.domain(2);
%         end
%     end
        
end