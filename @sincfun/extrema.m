function extrema(sf)
% plots a sincfun, together with its extrema
    
    deriv  = diff(sf);
    locs = roots(deriv);
    
    if ishold, hold_state = 1; else hold_state = 0; end
    
    plot(sf)
    hold on
    
    switch isempty(locs)
        
        case true
            
            plot(sf.domain,sf.ends,'or')
            
        case false
            
            vals = feval(sf,locs);
            plot(locs,vals,'or')
            ylim(1.05*[min(vals) max(vals)])
            
    end

    if ~hold_state, hold off, end    
    
end