function sfcplot(sf)
% SFCPLOT.M plots the equally spaced function values of 
% sincfun together with its Fourier coefficients.
% e.g. sfcplot(ff)

clf
[dummy,ss]=sincpts(sf);
% plot a vector of flipped function values
subplot(2,1,1), plot(ss,sf.vals,'.-'), grid on,
xlabel('periodic function values in s-space')
if min(sf.vals)~=max(sf.vals) 
    axis([ss(1) ss(end) min(sf.vals) max(sf.vals)]) 
end
% compute inverse fft as in the adaptive constructor and plot
% fftVals=abs(ifft(sf.vals))
fftVals = abs(fft(sf.vals))/(length(sf)/2); subplot(2,1,2), semilogy(fftVals)
xlabel('magnitude of fourier wavenumbers'), hold on 
semilogy([0 length(sf)],sf.scl*sincfunpref('tol')*[1 1], '-.r')
grid on, hold off, xlim([0 length(sf)]), ylim(sf.scl*[1e-20 1e0]) 

end


