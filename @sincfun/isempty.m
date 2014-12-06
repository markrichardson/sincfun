function empty = isempty(ff)
% ISEMPTY returns true if a sincfun has no 'vals' terms.
    if isempty(ff.domain) && isempty(ff.numterms)
        empty = true;
    else
        empty = false;
    end
end