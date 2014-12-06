function display(sf)
% defines the command prompt display for when RBF objects are created

if isempty(sf)
    disp([inputname(1) ' ='])
    fprintf(' empty sincfun \n')
    fprintf('      interval       length    endpoint values\n')
    fprintf('         []            []             []       \n')   
    fprintf('vertical scale = [] \n\n')    
else
    disp([inputname(1) ' ='])
    fprintf('   sincfun \n')
    fprintf('      interval       length    endpoint values\n')
    fprintf('    ( %3.5g,%3.5g )     %5d       %3.5g    %3.5g \n',sf.domain(1),sf.domain(2),length(sf),sf.endvals(1),sf.endvals(2))   
    fprintf('vertical scale = %3.5g \n\n',sf.scl)
end


% function display(sf)
% % defines the command prompt display for when RBF objects are created
% 
% if isempty(sf)
%     disp([inputname(1) ' ='])
%     fprintf(' empty sincfun \n')
%     fprintf('      domain       length    endpoint values\n')
%     fprintf('         []            []             []       \n')   
%     fprintf('vertical scale = [] \n\n')    
% else
%     disp([inputname(1) ' ='])
%     fprintf('   sincfun \n')
%     fprintf('        domain       length    endpoint values\n')
%     fprintf('x - ( %3.3g,%3.3g )     %5d       %3.5g    %3.5g \n',sf.domain(1),sf.domain(2),length(sf),sf.endvals(1),sf.endvals(2))   
%     fprintf('s - ( %3.1f,%3.1f )      vertical scale : %3.5g \n\n',sf.sdomain(1),sf.sdomain(2),sf.scl)   
% end