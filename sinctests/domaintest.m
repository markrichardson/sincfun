function pass = domaintest

f = @(x) sqrt(x);

f1 = sincfun(f,[0 1]);
f2 = sincfun(f,[0 0.01]);
f3 = sincfun(f,[0 0.0001]);

pass(1) = abs(length(f1) -length(f2)) < 3;
pass(2) = abs(length(f2) - length(f3)) < 3;


