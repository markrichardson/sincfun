function plot(sf,varargin)

if ishold
    ax = axis;
    main_plot(sf,varargin)
    hold on
    axis(ax)
else
%     clf
    main_plot(sf,varargin)
    hold off
end

end

function main_plot(sf,plot_prefs)

n=2001; 
xvals=linspace(sf.domain(1),sf.domain(2),n)'; 
yvals=feval(sf,xvals);

if isempty(plot_prefs)
    plot(xvals,yvals)
else
    if strcmp(plot_prefs{1},'.-')
        plot(xvals,yvals), hold on
        plot(sincpts(sf),sincvals(sf),'.'), hold off
    else
        plot(xvals,yvals,plot_prefs{1})
    end
end

mn = min(yvals); mx = max(yvals); cc = 0.05;

if length(sf)>1
    axis([sf.domain(1) sf.domain(2) ...
                min((1-cc)*mn,(1+cc)*mn) max((1-cc)*mx,(1+cc)*mx)])
end 

end