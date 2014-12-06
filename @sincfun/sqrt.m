function fout = sqrt(sf,varargin)

fout = sf.^0.5;
   
end


% if length(sf)==0
%     fout = sf.^0.5;
% else
%     fout = sincfun(@(x) sqrt(feval(sf,x)));
% end