function sinctest

userpref = sincfunpref;             % remember current user preferences
sincfunpref('reset');               % reset sincfun preferences to defaults

sincfundir = fileparts(which('sinctest.m'));  % get sincfun directory
dirname = fullfile(sincfundir,'sinctests');   % get sinctest directory

dirlist = dir( fullfile(dirname,'*.m') );  % search in directory for *.m
mfile = {dirlist.name};             % get names of the tests
namelen = 0;                        % get length of the filenames 
for k = 1:numel(mfile)
    namelen = max(namelen,length(mfile{k}));
end

% printout heading
fprintf('\nTesting %i functions:\n\n',length(mfile))

t = zeros(length(mfile),1);     % allocate storage for times
failed = t;                     % pass/fail markers

userpath = path;                % remember current user path
addpath(dirname)                % add sinctest directory to path

warnstate = warning;            % remember current warning settings
warning off                     % turn off warnings for the tests

for j = 1:length(mfile)         % loop through files in sinctests directory

    fun = mfile{j}(1:end-2);    % get name of test file
    
    % set up white space for printout
    ws = repmat(' ',1,namelen+1-length(fun)-length(num2str(j)));
    
    % print function number and name and leave space
    fprintf(['  Function #' num2str(j) ' (' fun ')... ', ws ])
    
    try 
        tic, pass = feval( fun );   % run current test
        t(j) = toc; 
        failed(j) = ~ all(pass);    % fail if any subtests fail
        if failed(j)
          fprintf('FAILED')       % print failure
        else
          fprintf('passed in %2.3fs ',t(j))   % print success
        end
    catch
        failed(j) = -1;             % print crashed
        fprintf('CRASHED!!! ') 
    end
    fprintf('\n')
end

% summary printouts
if all(~failed)
  fprintf('\nAll tests passed!\n\n')
else
  fprintf('\n%i failed and %i crashed\n\n',sum(failed>0),sum(failed<0))
end
ts = sum(t); tm = ts/60;

fprintf('Total time: %1.1f seconds = %1.1f minutes \n\n',ts,tm)

warning(warnstate);             % return warnings to previous state
sincfunpref(userpref);          % return to the original preferences
rmpath(dirname);                % remove sinctest from path
path(path,userpath);            % keep it if it was there before

end