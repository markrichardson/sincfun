function val = subsref(sincfun,index)
% SUBSREF.M - defines the subsref operation for sincfun objects

    switch index(1).type
    case '.'         
        if strcmp(index(1).subs,'vals')
            if length(index) == 2
                x = index(2).subs{1};
                vals = sincfun.vals;
                val = vals(x);
            else
               val = sincfun.vals; 
            end    
        elseif strcmp(index(1).subs,'h')
               val = sincfun.h; 
        elseif strcmp(index(1).subs,'endvals')
            if length(index) == 2
                x = index(2).subs{1};
                endvals = sincfun.endvals;
                val = endvals(x);
            else
                val = sincfun.endvals; 
            end 
        elseif strcmp(index(1).subs,'sdomain')
            if length(index) == 2
                x = index(2).subs{1};
                sdomain = sincfun.sdomain;
                val = sdomain(x);
            else
                val = sincfun.sdomain; 
            end             
        elseif strcmp(index(1).subs,'domain')
            if length(index) == 2
                x = index(2).subs{1};
                domain = sincfun.domain;
                val = domain(x);
            else
                val = sincfun.domain; 
            end
        elseif strcmp(index(1).subs,'numterms')
            if length(index) == 2
                x = index(2).subs{1};
                numterms = sincfun.numterms;
                val = numterms(x);
            else
                val = sincfun.numterms; 
            end   
        elseif strcmp(index(1).subs,'spts')
            if length(index) == 2
                x = index(2).subs{1};
                vals = sincfun.spts;
                val = vals(x);
            else
               val = sincfun.spts; 
            end  
        elseif strcmp(index(1).subs,'weights')
            if length(index) == 2
                x = index(2).subs{1};
                vals = sincfun.weights;
                val = vals(x);
            else
               val = sincfun.weights; 
            end      
        elseif strcmp(index(1).subs,'mobius')
            if length(index) == 2
                x = index(2).subs{1};
                mobius = sincfun.mobius;
                val = mobius(x);
            else
                val = sincfun.mobius; 
            end    
        elseif strcmp(index(1).subs,'scl')
            val = sincfun .scl;
        else
            error('wrong sincfun field!')
        end        
    case '()'
        x = index.subs{1};
        if isa(x,'sincfun')
            val = compose(sincfun,x);
        elseif isa(x,'double')
            val = feval(sincfun,x);
        else
            error('uncrecognised input argument')
        end
    end
end

