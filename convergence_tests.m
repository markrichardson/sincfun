%% Test convergence for sincfun class 
clc, clf, format long
func='x.^0.5';
interval=[0,1];
f = eval(['@(x)',func]);
a=interval(1); b=interval(2);
Trials=[1:30]; Nvals=[Trials-1].^2;
errors=zeros(length(Nvals),1);
xx=linspace(interval(1),interval(2),202)';
% xx=rand(200,1);
tic
for k=Trials
    m=k^2+1;
    ff=sincfun(f,m,interval);
    errors(k-Trials(1)+1)=max(abs(f(xx)-ff(xx)));
    display(['sqrt(m) = ' num2str(k) ...
            ', error = ' num2str(errors(k-Trials(1)+1))])
end
toc
% convergence plot
LW = 'LineWidth'; MS = 'MarkerSize';
semilogy(sqrt(Nvals),errors,'b*',MS,10), hold on
semilogy(linspace(sqrt(Nvals(1)),sqrt(Nvals(end)),1000),ff.scl*sincfunpref('tol'),'-r'), hold off
xlabel('sqrt(N)'), ylabel('|| error ||_{\infty}','Rotation',0)
ylim([1e-16 1e1]),
xlim([Trials(1)-1 Trials(end)-1]), grid on
displayfunc=strrep(func,'.^','^{'); 
displayfunc=[displayfunc '}'];
title(['convergence for f(x) = ' displayfunc ' on (0,1) '])
shg

%% Test convergence for sincfun class 
clc, clf, format long
func='x.^0.5';
interval=[0,1];
f = eval(['@(x)',func]);
a=interval(1); b=interval(2);
Trials=[1:30]; Nvals=[Trials-1].^2;
errors=zeros(length(Nvals),1);
xx=linspace(interval(1),interval(2),22)';
% xx=rand(200,1);
tic
for k=Trials
    m=k^2+1;
    ff=sincfun(f,m,interval);
    errors(k-Trials(1)+1)=max(abs(f(xx)-ff(xx)));
    display(['sqrt(m) = ' num2str(k) ...
            ', error = ' num2str(errors(k-Trials(1)+1))])
end
toc
% convergence plot
LW = 'LineWidth'; MS = 'MarkerSize';
semilogy(Nvals,errors,'b*',MS,10), hold on
semilogy(linspace(Nvals(1),Nvals(end),1000),ff.scl*sincfunpref('tol'),'-r'), hold off
xlabel('N'), ylabel('|| error ||_{\infty}','Rotation',0)
ylim([1e-16 1e1]),
xlim([Nvals(1) Nvals(end)]), grid on
displayfunc=strrep(func,'.^','^{'); 
displayfunc=[displayfunc '}'];
title(['convergence for f(x) = ' displayfunc ' on (0,1) '])
shg