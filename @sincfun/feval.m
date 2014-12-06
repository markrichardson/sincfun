
function val = feval(sf,x)

% tic
% val = stenger_1(sf,x);          % machine precision but slow
% val = stenger_2(sf,x);          % my modified stenger: fairly fast machine precsion formula
% val = sinc_bary(sf,x);          % fast but only linearly converging barycentric formula
% val = sinc_bary_2(sf,x);        % UNSTABLE barycenric formula (Berrut)
% val = sinc_bary_3(sf,x);        % stable barycenric formala accurate to around 1e-12 (Gautschi)
% val = sinc_bary_4(sf,x);        % adjustments made for dealing with sincpoints, accurate to around 1e-12 (Gautschi)
% val = sinc_bary_5(sf,x);          % stable and accurate to machine precsion, but slower than 2,3,4
val = sinc_bary_weighted(sf,x);   % Berrut's weighted formula to increas convergence of denominator
                                  % Machine precision and FAST! But, fails for sincfun binary operations
% val = sinc_bary_weighted_2(sf,x); % different weight function, (sinc(x/beta)^alpha) 
                                  % but with same effect as before        
% val =  repl_basis(sf,x);                                  
                                  
% toc                                  
end

% Speed is time in seconds to evaluate the first segment of convergence3.m
% for the function f=@(x) x.^0.5 over trials=[1:50] with 202 evaluations 
% --------------------------------------------------------------------------------
%                          Accuracy            Speed          Bin-ops converge?
% --------------------------------------------------------------------------------
% stenger_1            Machine Precision     2.921763 s            Yes
% stenger_2            Machine Precision     1.238417 s            Yes
% sinc_bary            Slow linear conv      0.595762 s      Yes? (with lower tol)
% sinc_bary_2               UNSTABLE         0.557099 s            No
% sinc_bary_3               ~1e-12           0.527580 s      Yes? (with lower tol)      
% sinc_bary_4               ~1e-12           0.597344 s      Yes? (with lower tol)
% sinc_bary_5          Machine Precison      1.492769 s           YES!!!
% sinc_bary_weighted   Machine Precison      0.767031 s            NO
% sinc_bary_weighted_2 Machine Precison      0.727788 s            No   

% CONCLUSION: Use stenger_2 until we can find a way to speed up sinc_bary_5