%% gui progress bar

N = 100;

PB = ProgressBar(N);
for n = 1:N
    pause(0.5)      % Loop body

    PB.count        % or count(PB)
end

%% gui progress bar, task name

N = 100;
task_name = 'For loop';

PB = ProgressBar(N,task_name);
for n = 1:N
    pause(0.2)      % Loop body

    PB.count        % or count(PB)
end

%% gui progress bar, parfor

N = 600;
task_name = 'Parfor loop';

PB = ProgressBar(N,task_name);
parfor n = 1:N
    pause(0.5*rand)  % Loop body

    count(PB)        % It is recommended to use count(PB)
                     % instead of PB.count in parfor loop.
end

%% cli progress bar

N = 100;
task_name = 'For loop';

PB = ProgressBar(N,task_name,'cli');
for n = 1:N
    pause(0.5)      % Loop body

    PB.count        % or count(PB)
end

%% cli progress bar, without name

N = 100;

PB = ProgressBar(N,[],'cli');
for n = 1:N
    pause(0.5)      % Loop body

    PB.count        % or count(PB)
end

%% cli progress bar, parfor

N = 600;
task_name = 'Parfor loop';

PB = ProgressBar(N,task_name,'cli');
parfor n = 1:N
    pause(0.5*rand)  % Loop body

    count(PB)        % It is recommended to use count(PB)
                     % instead of PB.count in parfor loop.
end

%% ProgressBar vs. waitbar (MATLAB builtin)

clear; clc; close all;
N = 500000;

% -------------- waitbar (MATLAB builtin)
fprintf('waitbar (MATLAB builtin)\n')
tic
f = waitbar(0,'waitbar');
for n = 1:N, waitbar(n/N,f); end
close(f)
toc

% -------------- ProgressBar gui
tic
PB = ProgressBar(N,'ProgressBar gui');
for n = 1:N, PB.count; end
toc

% -------------- ProgressBar cli
tic
PB = ProgressBar(N,'ProgressBar cli','cli');
for n = 1:N, PB.count; end
toc

