%% gui progress bar

N = 100;

PB = ProgressBar(N);
for ii = 1:N
    pause(0.5)      % Loop body

    PB.count        % or count(PB)
end

%% gui progress bar, task name

N = 100;
task_name = 'For loop';

PB = ProgressBar(N,task_name);
for ii = 1:N
    pause(0.2)      % Loop body

    PB.count        % or count(PB)
end

%% gui progress bar, parfor

N = 600;
task_name = 'Parfor loop';

PB = ProgressBar(N,task_name);
parfor ii = 1:N
    pause(0.5*rand)  % Loop body

    count(PB)        % It is recommended to use count(PB)
                     % instead of PB.count in parfor loop.
end

%% cli progress bar

N = 100;
task_name = 'For loop';

PB = ProgressBar(N,task_name,'cli');
for ii = 1:N
    pause(0.5)      % Loop body

    PB.count        % or count(PB)
end

%% cli progress bar, without name

N = 100;

PB = ProgressBar(N,[],'cli');
for ii = 1:N
    pause(0.5)      % Loop body

    PB.count        % or count(PB)
end

%% cli progress bar, parfor

N = 600;
task_name = 'Parfor loop';

PB = ProgressBar(N,task_name,'cli');
parfor ii = 1:N
    pause(0.5*rand)  % Loop body

    count(PB)        % It is recommended to use count(PB)
                     % instead of PB.count in parfor loop.
end
