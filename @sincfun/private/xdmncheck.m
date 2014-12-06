function truefalse = xdmncheck(ff,gg)
% checks that the x-domains of ff and gg are the same

if ff.domain(1) == gg.domain(1) && ff.domain(2) == gg.domain (2)
    truefalse = true;
else
    truefalse = false;
end

end