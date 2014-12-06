function [min_val,x_pos] = min(sf)

    % differentiate and evaluate at the extrema
    deriv = diff(sf);
    extrema = [sf.domain(1);roots(deriv);sf.domain(2)];
    extrema_vals = feval(sf,extrema);
    min_val = min(extrema_vals);
    x_pos = extrema(extrema_vals==min_val);

%     % if there are no roots, then the function is monotonic and the maximum
%     % values is at one of the endponts of the interval
%     if isempty(min_val)
%         min_val = min(sf.endvals);
%         if min_val == sf.endvals(1); x_pos = sf.domain(1);
%         else x_pos = sf.domain(2);
%         end
%     end
        
end