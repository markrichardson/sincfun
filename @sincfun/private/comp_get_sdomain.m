function sdomain = comp_get_sdomain(ff,op)
% replicates get_sdomain in the constructor, but does not call feval
% and instead calls an internal barycentric formula. Calling feval has a
% basic minimum cost associated with it and this proves to be inefficient
% when making several single evaluations as is required for the binary
% search in get_sdomain. Called from 'comp' - compose

a = ff.domain(1); b = ff.domain(2); 
fa = ff.endvals(1); fb = ff.endvals(2);    
eval(['phi_inv=' sincfunpref('invmap') ';'])
eval(['phi=' sincfunpref('map') ';'])
MM = ff.numterms(1); NN = ff.numterms(2); 
h = ff.h; xk = sincpts(ff); f=ff.vals;

% strange things happen if fa fb are near to zero. For the purposes of 
% computing the new sdomain, shift upwards by 1

if abs(fa) < 0.9 || abs(fb) < 0.9
    fa = fa +1; fb = fb + 1;
    % fb may now be < 0.9
    if abs(fa) < 0.9 || abs(fb) < 0.9
        fa = fa +1; fb = fb + 1;
    end
end


% what will the new endpoint values be?
newfa = op(fa);
newfb = op(fb);

% estimate scale
xx = linspace(a,b,12); x = xx(2:end-1);
scl = max(abs(feval(ff,x))); tol = scl*sincfunpref('tol');

% work out absoute maximum and minimum possible values for s
if a == 0,  s_infimum = phi(realmin);
else        s_infimum = phi(a+eps(a)); end
if b == 0,  s_supremum = -phi(realmin);
else        s_supremum = phi(b-eps(b)); end

searchtol = 2e0;

% do binary searches. First, smin;
A = s_infimum; B = 0; Mlast = 0; M = Inf;  
while abs(M-Mlast) > searchtol
    Mlast = M; M = (A+B)/2;
%     abs(op_bary(op,phi_inv(M),a,b,fa,fb,phi,MM,NN,h,xk,f)-newfa)
%     evaluate and subtract new endpoint value 
    if abs(op_bary(op,phi_inv(M),a,b,fa,fb,phi,MM,NN,h,xk,f)-newfa) > tol 
            B = M; 
    else    A = M; 
    end
end
smin = M;

% Next, smax;
A = 0; B = s_supremum; Mlast = 0; M = Inf;
while abs(M-Mlast) > searchtol
    Mlast = M; M = (A+B)/2;
    % evaluate and subtract endpoint value 
    if abs(op_bary(op,phi_inv(M),a,b,fa,fb,phi,MM,NN,h,xk,f)-newfb) > tol 
            A = M; 
    else    B = M; 
    end
end
smax = M;

sdomain = [smin smax];

end

function value = op_bary(op,x,a,b,fa,fb,phi,M,N,h,xk,f)
% quickly evaluates op(ff) one point at a time using Gautschi's formula

zz = phi(x);                            % evaluation point in (-inf,inf)
k0 = round(zz/h);                       % compute nearest integer k0
t = zz/h-k0;                            % compute t value 
sincpt_loc = find(x==xk, 1);
if isempty(sincpt_loc)
   qq = (-M-k0:N-k0);                   % index set
   val = (t*(-1).^qq./(t-qq))*f;        % barycentric formula
   fval = sin(pi*t)/(pi*t)*val;
else
   fval = f(sincpt_loc);
end 
% add on linear correction and compute op()
value = op(fval + (fb-fa)/(b-a)*(x-a) + fa); 
end




% function sdomain = comp_get_sdomain(ff,op)
% % replicates get_sdomain in the constructor, but does not call feval
% % and instead calls an internal barycentric formula. Calling feval has a
% % basic minimum cost associated with it and this proves to be inefficient
% % when making several single evaluations as is required for the binary
% % search in get_sdomain.
% 
% a = ff.domain(1); b = ff.domain(2); 
% fa = ff.endvals(1); fb = ff.endvals(2);    
% eval(['phi_inv=' sincfunpref('invmap') ';'])
% eval(['phi=' sincfunpref('map') ';'])
% MM = ff.numterms(1); NN = ff.numterms(2); 
% h = ff.h; xk = sincpts(ff); f = ff.vals;
% 
% % what will the new endpoint values be?
% newfa = op(fa);
% newfb = op(fb);
% 
% % estimate scale
% xx = linspace(a,b,12); x = xx(2:end-1);
% scl = max(abs(feval(ff,x))); tol = scl*sincfunpref('tol');
% 
% % work out absoute maximum and minimum possible values for s
% if a == 0,  s_infimum = phi(realmin);
% else        s_infimum = phi(a+eps(a)); end
% if b == 0,  s_supremum = -phi(realmin);
% else        s_supremum = phi(b-eps(b)); end
% 
% searchtol = 2e0;
% 
% % do binary searches. First, smin;
% A = s_infimum; B = 0; Mlast = 0; M = Inf;  
% while abs(M-Mlast) > searchtol
%     Mlast = M; M = (A+B)/2;
%     abs(op_bary(op,phi_inv(M),a,b,fa,fb,phi,MM,NN,h,xk,f)-newfa)
% %     evaluate and subtract new endpoint value 
%     if abs(op_bary(op,phi_inv(M),a,b,fa,fb,phi,MM,NN,h,xk,f)-newfa) > tol 
%             B = M; 
%     else    A = M; 
%     end
% end
% smin = M;
% 
% % Next, smax;
% A = 0; B = s_supremum; Mlast = 0; M = Inf;
% while abs(M-Mlast) > searchtol
%     Mlast = M; M = (A+B)/2;
%     % evaluate and subtract endpoint value 
%     if abs(op_bary(op,phi_inv(M),a,b,fa,fb,phi,MM,NN,h,xk,f)-newfb) > tol 
%             A = M; 
%     else    B = M; 
%     end
% end
% smax = M;
% 
% sdomain = [smin smax];
% 
% end
% 
% function value = op_bary(op,x,a,b,fa,fb,phi,M,N,h,xk,f)
% % quickly evaluates op(ff) one point at a time using Gautchi's formula
% 
% zz = phi(x);                            % evaluation point in (-inf,inf)
% k0 = round(zz/h);                       % compute nearest integer k0
% t = zz/h-k0;                            % compute t value 
% sincpt_loc = find(x==xk, 1);
% if isempty(sincpt_loc)
%    qq = (-M-k0:N-k0);                   % index set
%    val = (t*(-1).^qq./(t-qq))*f;        % barycentric formula
%    fval = sin(pi*t)/(pi*t)*val;
% else
%    fval = f(sincpt_loc);
% end 
% % add on linear correction and compute op()
% value = op(fval + (fb-fa)/(b-a)*(x-a) + fa); 
% end

