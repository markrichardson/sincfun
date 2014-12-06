function pass = adaptdegree
% check the length of two sincfuns to make sure the 
% constructor is stopping at the right point

pass(1) = length(sincfun('sin(10*exp(3*x))')) < 2500;
pass(2) = length(sincfun('sin(10*x)+1e-3*sin(100*x)+1e-6*sin(777*x)')) < 6000;
