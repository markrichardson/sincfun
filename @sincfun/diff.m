

% function sfout = diff(sf)
% 
%     cheb = chebfun(@(x) feval(sf,x),sf.domain);
%     dcheb = diff(cheb);
%     sfout = sincfun(@(x) dcheb(x),sf.domain);
% 
% end

%%%%%%%%%%%%%%%

% function dff = diff(ff)
% 
% 
%     xx = sincpts(ff);
%     dvals = deriv(ff,xx);
%     dff = ff;
%     dff.vals = dvals;
%     dff.vals(1) = ff.vals(1);
%     dff.vals(end) = ff.vals(end);
% end

function dff = diff(ff,xx)

    dff = ff; 
    
%     xx = sincpts(ff); 
    

    a = ff.domain(1); b = ff.domain(2);     % get domain 
    fa = ff.endvals(1); fb = ff.endvals(2); % get endpoint function values

    phi = @(x) log((x-a)./(b-x));
    m = -ff.numterms(1); n = ff.numterms(2);% no. of terms in sum
    h = ff.h;
    gk = ff.vals;                           % sincfun values at sincpoints
    ss = phi(xx);
%     ss = ff.spts; 

    sum = zeros(size(xx));
    
    function dsincval = dsinc(k)     
        dsincval = cos(pi*(ss/h-k))./(ss-k*h) - sin(pi*(ss/h-k))./(ss/h-k)./(ss/h-k)/pi/h;
        dsincval(~isfinite(dsincval))=0;
    end
    
%     cut = 0;        % cut 5 terms from each end

    for k = m:n
        sum = sum + gk(k-m+1)*dsinc(k);  
    end
    
    dval = (b-a)./(xx-a)./(b-xx).*sum;
    dvals = dval + (fb-fa)/(b-a);
    dfa = dvals(1); dfb = dvals(end);
    dff.vals = dvals - dfa - (dfb-dfa)/(b-a)*xx ;
    dff.endvals(1) = dfa;
    dff.endvals(2) = dfb;
    
    dff = dvals;
    
end



%%%%%%%%%%%%%%%


% function sfout = diff(sf)
% 
%    sfout = sf;
%    [values,derivs] = ad_stenger_2(sf,sincpts(sf));
% 
% %    t = adfun(@(x) ad_stenger_2(sf,x),1);
% %    values = t(sincpts(sf));
% 
%    sfout.vals = values;
%    sfout.vals = derivs;
% %    sfout.ends = [pi -pi];
%    
% end


% function sfout = diff(sf)
% 
%     sfout = sf;
%     sfout.vals = sinc_derivative(sf,sincpts(sf));
% 
% end







% function sfout = diff(sf)
% 
%     sfout = sf;
% 
%   gg = sf;
% 
%   N=length(sf);
%   [x,s]=sincpts(gg);
%   
%   s_min=s(1);
%   s_max=s(end);
%   h = gg.h;
%   
%   (s_max-s_min)/h;
%   
%   domain=[s_min s_max];
%   
%   v = gg.vals; vprime = sincvals(gg);
%   v_hat = fft(v);
%   w_hat = 1i*[0:N/2-1 0 -N/2+1:-1]' .* v_hat*2*pi/(domain(2)-domain(1));
%   w = real(ifft(w_hat));
%   
%   sfout.vals=w;
%   
%   subplot(1,2,1), plot(s,v,'.-','markersize',13)
%   axis([domain min(v) max(v)]), grid on
%   subplot(1,2,2), plot(s,w,'.-','markersize',13)
%   axis([domain min(w) max(w)]), grid on
%   error = norm(w-vprime,inf);
%   text((domain(1)+domain(2))/2,1.7,['max error = ' num2str(error)])
%   
% end
% 
% function sfout = diff(sf)
% 
% % % sfout = sincfun(@(x) sinc_derivative(sf,x));
% % % sfout = sincfun(@(x) sinc_derivative(sf,x),length(sf));
% % 
% % % xx=sincpts(sf);
% % 
% % sfout = sf;
% % 
% % % xx=[0:0.001:1]';
% % % xx=(1+chebpts(100))/2;
% % % yy=sinc_derivative(sf,xx);
% % % norm(yy-exp(xx))
% % % plot(xx,yy)
% % 
% % %   length([0:N/2-1 0 -N/2+1:-1])
% % %   length(sf)
% %   
% % %   v = exp(sin(xx)); % vprime = cos(x).*v;
% %   v_hat = fft(sincvals(sf));
% %   w_hat = 1i*[0:length(sf)-1]' .* v_hat;
% %   
% % %   abs(w_hat)
% % %   
% % %   semilogy(abs(w_hat))
% %   
% %   w = real(ifft(w_hat));
% % 
% %   sfout.vals=w;
% %   sfout.ends=[w(1) w(end)];
%   
% end
% 
% function fvals = sinc_derivative(sf,x)
% % The stable version of the barycentric formula given in 
% % [Gautschi 2000] p792. Converges down to machine precision but is slower to
% % evaluate than sinc_bary_3 or sinc_bary_4
% 
% a = sf.domain(1); b = sf.domain(2);     % get domain 
% fa=sf.ends(1); fb=sf.ends(2);           % get endpoint function values
% eval(['phi =' sf.prefs.map ';'])        % define mapping (a,b)->(-inf,inf)
% M = sf.numterms(1); N = sf.numterms(2); % no. of terms in sum
% h=sf.h;                                 % stepsize
% xk=sincpts(sf);                         % sincpoints
% f=sf.vals;                              % sincfun values at sincpoints
% 
% % check that all evaluation points x are in [a,b]
% if any(x < a) || any(x > b)
%     error('evaluations must be in the interval [a,b]')
% end
% 
% x_orig=x;           % make a note of the original x values 
%                     % (the endpoints will now be changed) 
% % deal with the values x==a and x==b 
% if any(x==a)
%     if a ~= 0, x(x==a) = a+eps(a); else x(x==a) = eps(eps); end
% end
% if any(x==b)
%     if b ~= 0, x(x==b) = b-eps(b); else x(x==b) = -eps(eps); end
% end
% 
% zz = phi(x);                            % evaluation points in (-inf,inf)
% k0=round(zz/h);                         % compute nearest integers k0
% t = zz/h-k0;                            % compute t values 
% 
% vals1 = zeros(size(zz));
% vals2 = vals1;
% % for each point to be evaluated, do the following:
% for j=1:length(x)
%    % check to see if evaluation node is a sinc point
%    sincpt_loc=find(x(j)==xk, 1);
%    if isempty(sincpt_loc)
%        qq = (-M-k0(j):N-k0(j));                         % index set
%        vals1(j)=(t(j)*(-1).^qq./(t(j)-qq))*f;           
%        vals2(j)=(t(j)^2*(-1).^qq./(t(j)-qq).^2)*f;    % barycentric formula
%    else
%        vals1(j)=f(sincpt_loc); 
%        vals2(j)=f(sincpt_loc);
%    end
% end  
%     
% cosc_pi_t=cos(pi*t)./t;        
% sinc_pi_t=sin(pi*t)./(pi*t.^2);             % sin(pi*t)./sin(pi*t) term
% 
% % [cosc_pi_t.*vals1]
% % [cosc_pi_t.*vals1-sinc_pi_t.*vals2]
% 
% dphi = (b-a)./((x-a).*(b-x))/h;
% % x 
% % dphi
% % norm(dphi)
% 
% % size(cosc_pi_t.*vals1)
% % size(sinc_pi_t.*vals2)
% % size(dphi)
% 
% fvals = dphi.*(cosc_pi_t.*vals1 - sinc_pi_t.*vals2);    % compute answer
% 
% % [find(isnan(fvals)) find(isinf(fvals))]
% 
% fvals=fvals + (fb-fa)./(b-a);   % add on the linear correction
% fvals(x_orig==a)=fa; fvals(x_orig==b)=fb;
% 
% end



% %% sinc_pi_t(isnan(sinc_pi_t))=1;          % set value to 1 if t=0;

% function sfout = diff(sf)
% % DIFF - computes the derivative of a sincfun object by differentiating the
% % sinc expansion manually and sending the result to the constructor.
% % The derivative of the sinc function y = sin(pi*x)./(pi*x) is given by:
% % y' = cos(pi*x)./x - sinc(pi*x)./x
% 
% % Assume that the resolution of sf is sufficient to resolve diff(sf)
% % step = 1e-3;
% % x= [sf.domain(1)+step:step:sf.domain(2)-step]';
% 
% % y = sinc_derivative(sf,x);
% 
% % splitting on;
% % cheb = chebfun(@(x) feval(sf,x),[sf.domain(1) sf.domain(2)]);
% % dcheb=diff(cheb);
% % 
% % sfout = sincfun(@(x) dcheb(x),[sf.domain(1) sf.domain(2)]);
% 
% % sfout = sincfun(@(x) sinc_derivative(sf,x));
% 
% xx=sincpts(sf);
% yy=sinc_derivative(sf,xx);
% 
% plot(xx,yy)
% 
% % yy-6*pi*cos(6*pi*xx)
% 
% % end
% % 
% function val = sinc_derivative(sf,x)
% % evaluate the derivative of a sincfun at x. This just interpolates using 
% % a basis of derivatives of the  sinc functions (similar to the stenger_2
% % evaluation routine).
% 
% % extract preferences and fields
% % prefs=sf.prefs; numterms=sf.numterms; domain=sf.domain;
% a = sf.domain(1); b = sf.domain(2); 
% M = sf.numterms(1); N = sf.numterms(2); 
% h=sf.h;
% 
% % if there are still numbers outside of the interval, give an error
% if any(x < a) || any(x > b)
%     error('evaluations must be in the interval [a,b]')
% end
% 
% % deal with the values x==a and x==b 
% if x(1) == a
%     if a ~= 0, x(x==a) = a+eps(a); else x(x==a) = eps(0); end
% end
% if x(end) == b
%     if b ~= 0, x(x==b) = b-eps(b); else x(x==b) = -eps(0); end
% end
% 
% % set very small values of x to 0;
% x(abs(x)<1e-30)=0;
% 
% zz=log((x-a)./(b-x))/h;   f=sf.vals;   val=zeros(size(x));
% 
% for k=-M:N
%     % compute the newval:
%     newval = (cos(pi*(zz-k))-sinc(zz-k))*f(k+M+1)./(zz-k);
%     % elements corresponding to sincpoints will be NaN, so set to zero:
%     newval(isnan(newval)) = 0;
%     val = val + newval;
% end
% 
% fa=sf.endvals(1); fb=sf.endvals(2);
% % function defining the derivative
% dphi = (b-a)./((x-a).*(b-x))/h;
% % norm(dphi)
% 
% % compute derivative and add on the constant;
% val = dphi.*val + (fb-fa)/(b-a);
% 
% % compute interpolant value at the evaluation points 
% % (adding on the linear term)
% % val=val + (fb-fa)./(b-a).*(x-a) + fa;
% 
% % val(x==a)=sf.ends(1);
% % val(x==b)=sf.ends(2);
% 
% end
% 
% % sinc function
% function val=sinc(x)
%     val = sin(pi*x)./(pi*x);
%     val(isnan(val)) = 1;
% end
% 
