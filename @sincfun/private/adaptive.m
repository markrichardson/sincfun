function [numterms,h,spts,vals,scl] = adaptive(f,endvals,sdomain,specs)
% ADAPTIVE - adaptive constructor of sincfun objects

a = specs.domain(1);                % left boundary of x-domain
b = specs.domain(2);                % right boundary of x-domain
eval(['phi_inv=' specs.invmap ';']) % inverse mapping (-inf,inf) -> (a,b)

fa = endvals(1); fb = endvals(2);   % function values at x-domain endpoints 
smin = sdomain(1);                  % left boundary of s-domain
smax = sdomain(2);                  % right boundary of s-domain
s_interval = smax - smin;           % width of s-interval

k = 7;                              % initialise 
while k < 16                        % search through 256, 512, ...
    k = k+1; N = 2^k;               % update k and N
    h = s_interval/N;               % determine stepsize
    m = floor(abs(smin)/h);         % terms on left 
    n = N - m - 1;                  % terms on right 
    sk = (-m:n)'*h;                 % equispaced nodes in s-domain
    xk = phi_inv(sk);               % sincpoints in x-domain
    g = f(xk);                      % function values at sincpoints
    fftVals = abs(fft(g))/(N/2);    % take fft of the data and rescale
    scl = max(abs(g+(fb-fa)./(b-a).*(xk-a) + fa)); % vertical scale (est.)
    tol = scl*specs.tol;            % tolerance
    % ---------------------------------------------------------------------
    % sub-routine to display decay of coefficients in a figure
    if sincfunpref('showcon') || specs.showcon
        plotfouriercoeffs(sk,g,fftVals,tol,scl)
    end
    % ---------------------------------------------------------------------
    if k <= 11
        smallCoeffs = sum(fftVals<tol); % how many fourier coeffs are neglible?
    else
        smallCoeffs = sum(fftVals<tol*5);
    end
    if smallCoeffs > N/10           % exit the while loop if > 10% of the 
        break; end                  % fourier coeffs are less than tol
end

if k < 16
    
    if N-smallCoeffs == 0
        [numterms,h,spts,vals] = linearSincfun;
        scl = max(abs([fa,fb]));
        return
    end
    
    sfLen = ceil(1.08*(N-smallCoeffs)); % determine the final length 
    h = s_interval/sfLen;           % compute final stepsize
    m = floor(abs(smin)/h);         % number of terms on the left
    n = sfLen - m - 1;              % number of terms on the right
else
    h = s_interval/N;               % if k = 16, sincfun has not converged   
    m = floor(abs(smin)/h);         % so do alternative computations and 
    n = N - m - 1;                  % issue a warning
    warning('sincfun did not converge!') %#ok<WNTAG>
end

spts = (-m:n)'*h;                   % final equispaced abscissae
xpts = phi_inv(spts);               % final sincpoints
vals = f(xpts);                     % final sincvals
numterms = [m n];                   % store numterms field

end

function plotfouriercoeffs(sk,g,fftVals,tol,scl)
% plots function values in s-plane and fourier coefficients for each pass  
    clf
    subplot(2,1,1), plot(sk,g,'.-'), grid on
    xlabel('periodic function values in s-space')
    if min(g)~=max(g) 
        axis([sk(1) sk(end) min(g) max(g)]) 
    end
    subplot(2,1,2), semilogy(fftVals)
    xlabel('magnitude of fourier wavenumbers')
    hold on
    semilogy([0 length(g)],tol*[1 1], '-.r'), grid on
    hold off
    xlim([0 length(g)]), ylim(scl*[1e-20 1e0])
    pause
end
% 
% function [numterms,h,spts,vals,scl] = adaptive(f,endvals,sdomain,specs)
% % ADAPTIVE - adaptive constructor of sincfun objects
% 
% a = specs.domain(1);                % left boundary of x-domain
% b = specs.domain(2);                % right boundary of x-domain
% eval(['phi_inv=' specs.invmap ';']) % inverse mapping (-inf,inf) -> (a,b)
% 
% fa = endvals(1); fb = endvals(2);   % function values at x-domain endpoints 
% smin = sdomain(1);                  % left boundary of s-domain
% smax = sdomain(2);                  % right boundary of s-domain
% s_interval = smax - smin;           % width of s-interval
% 
% k = 7;                              % initialise 
% while k < 16                        % search through 256, 512, ...
%     k = k+1; N = 2^k;               % update k and N
% %     h = s_interval/N;               % determine stepsize
% %     m = floor(abs(smin)/h);         % terms on left 
% %     n = N - m - 1;                  % terms on right 
% %     sk = (-m:n)'*h;                 % equispaced nodes in s-domain
%     sk = linspace(smin,smax,N)';
%     h = sk(2)-sk(1);
%     xk = phi_inv(sk);               % sincpoints in x-domain
%     g = f(xk);                      % function values at sincpoints
%     fftg = fft(g);
%     fftVals = abs(fftg)/(N/2);    % take fft of the data and rescale
%     scl = max(abs(g+(fb-fa)./(b-a).*(xk-a) + fa)); % vertical scale (est.)
%     tol = scl*specs.tol;            % tolerance
%     % ---------------------------------------------------------------------
%     % sub-routine to display decay of coefficients in a figure
%     if sincfunpref('showcon') || specs.showcon
%         plotfouriercoeffs(sk,g,fftVals,tol,scl)
%     end
%     % ---------------------------------------------------------------------
%     if k <= 11
%         smallCoeffs = sum(fftVals<tol); % how many fourier coeffs are neglible?
%     else
%         smallCoeffs = sum(fftVals<tol*5);
%     end
%     if smallCoeffs > N/10           % exit the while loop if > 10% of the 
%         break; end                  % fourier coeffs are less than tol
% end
% 
% spts = linspace(smin,smax,N)';      % final equispaced abscissae
% vals = ifft(fftg);                  % final sincvals
% numterms = [0 0];   
% % 
% % % how many terms to chop off each sid of the centre?
% % trunc = floor(sum(abs(fftg)/(N/2)<tol/10)/2)
% % 
% % % % check: wavenumber vectors 
% % % wavenums = [0:N/2 -N/2+1:-1]'
% % % [wavenums(1:N/2-trunc+1) ; wavenums(N/2+trunc+2:end)]
% % 
% % % truncate the fft vector
% % fftTrunc = [fftg(1:N/2-trunc+1) ; fftg(N/2+trunc+2:end)];
% % 
% % NN=length(fftTrunc);
% % 
% % % % check lengths are correct
% % % [length(fftTrunc),length(fftg)-2*trunc]
% % semilogy(abs(fftTrunc)/(N/2)), ylim([1e-18 1e1]), xlim([0 NN])
% % set(gca,'YTick',[1e-16 1e-8 1]), 
% % set(gca,'XTick',[0 round(NN/4) NN/2 round(3*NN/4) NN]), grid on
% % shg
% % 
% % % compute inverse fft to get function values
% % vals=real(ifft(fftTrunc))
% % 
% % % what were the effective smin and smax undet the (m:n)'*h computation?
% % SMIN=-m*h
% % SMAX=n*h
% % SINT = SMAX - SMIN
% % hh = s_interval/NN
% % 
% % smin/hh
% 
% % if k < 16
% %     sfLen = ceil(1.08*(N-smallCoeffs)); % determine the final length 
% %     h = s_interval/sfLen;           % compute final stepsize
% %     m = floor(abs(smin)/h);         % number of terms on the left
% %     n = sfLen - m - 1;              % number of terms on the right
% % else
% %     h = s_interval/N;               % if k = 16, sincfun has not converged   
% %     m = floor(abs(smin)/h);         % so do alternative computations and 
% %     n = N - m - 1;                  % issue a warning
% %     warning('sincfun did not converge!') %#ok<WNTAG>
% % end
% % 
% % spts = (-m:n)'*h;                   % final equispaced abscissae
% % xpts = phi_inv(spts);               % final sincpoints
% % vals = f(xpts);                     % final sincvals
% % numterms = [m n];                   % store numterms field
% 
% end
% 
% function plotfouriercoeffs(sk,g,fftVals,tol,scl)
% % plots function values in s-plane and fourier coefficients for each pass  
%     clf
%     subplot(2,1,1), plot(sk,g,'.-'), grid on
%     xlabel('periodic function values in s-space')
%     if min(g)~=max(g) 
%         axis([sk(1) sk(end) min(g) max(g)]) 
%     end
%     subplot(2,1,2), semilogy(fftVals)
%     xlabel('magnitude of fourier wavenumbers')
%     hold on
%     semilogy([0 length(g)],tol*[1 1], '-.r'), grid on
%     hold off
%     xlim([0 length(g)]), ylim(scl*[1e-20 1e0])
%     pause
% end
% 
% 
% 
% % smallCoeffs
% % wavenumbers = [0:N/2 -N/2+1:-1]';
% % newind = [wavenumbers(N/2+2:end) ; wavenumbers(1:N/2+1)];
% % reord = abs([fftg(N/2+2:end) ; fftg(1:N/2+1)])/(N/2);
% % 
% % for kk = 1:N
% %     fprintf(' %+5i   %1.15f\n',newind(kk),reord(kk)) 
% % end
% % 
% % firstind = find(reord>tol/10,1,'first');
% % lastind = find(reord>tol/10,1,'last');
% % 
% % trunc = max(firstind,N-lastind);
% % 
% % choppedind = newind(trunc:N-trunc+1);
% % choppedcoeffs = reord(trunc:N-trunc+1);
% % 
% % for kk = 1:length(choppedcoeffs)
% %     fprintf(' %+5i   %1.15f\n',choppedind(kk),choppedcoeffs(kk)) 
% % end
% % 
% % % now put back into reverse-wraparound order
% % NN = length(choppedcoeffs);
% % 
% % % newvals = [choppedind(NN/2:end) ; choppedind(1:NN/2-1)]
% % 
% % newvals = [choppedcoeffs(NN/2:end) ; choppedcoeffs(1:NN/2-1)]
% % 
% % semilogy(choppedcoeffs)