function splotvals(ff,varargin)
% SPLOT 
% Plots a sincfun in the s-plane

if ishold
    main_splot(ff,varargin)
    hold on
else
    clf
    main_splot(ff,varargin)
    hold off
end

end

function main_splot(ff,plot_prefs)

% get s sinc-points in x and s domains
[~,ss]=sincpts(ff);

% normal plot
if isempty(plot_prefs)
    plot(ss,ff.vals)
else
    plot(ss,ff.vals,plot_prefs{1})
end

if length(ff)>1
    xlim([ss(1) ss(end)]);
    ylim([min(ff.vals) max(ff.vals)])
end 

end